import UIKit

protocol ScheduleViewControllerDelegateProtocol: AnyObject {
    func didSelectDays(_ days: Set<WeekDay>)
}

final class ScheduleViewController: UIViewController {
    let textLabel: UILabel = {
        let text = UILabel()
        text.text = "Расписание"
        text.font = .systemFont(ofSize: 16, weight: .medium)
        text.textColor = .ypBlack
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedDays: Set<WeekDay> = []
    weak var delegate: ScheduleViewControllerDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(textLabel)
        view.addSubview(tableView)
        view.addSubview(acceptButton)
        tableView.delegate = self
        tableView.dataSource = self
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 78),
            
            tableView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            acceptButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func acceptButtonTapped() {
        delegate?.didSelectDays(selectedDays)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else { return UITableViewCell() }
        cell.configure(with: WeekDay.orderedCases[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}

extension ScheduleViewController: ScheduleCellDelegateProtocol {
    func didToggleSwitch(for day: WeekDay, isOn: Bool) {
        if isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}
