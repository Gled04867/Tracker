import UIKit

protocol ScheduleCellDelegateProtocol: AnyObject {
    func didToggleSwitch(for day: WeekDay, isOn: Bool)
}

final class ScheduleCell: UITableViewCell {
    static let identifier = "ScheduleCell"
    var titleLabel = UILabel()
    let switchView = UISwitch()
    weak var delegate: ScheduleCellDelegateProtocol?
    private var day: WeekDay?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .ypBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryView = switchView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with day: WeekDay) {
        self.day = day
        titleLabel.text = day.title
        switchView.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }
    
    @objc private func switchToggled() {
        guard let day else { return }
        delegate?.didToggleSwitch(for: day, isOn: switchView.isOn)
    }
}
