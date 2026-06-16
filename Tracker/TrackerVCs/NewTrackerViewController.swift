import UIKit

protocol NewTrackerViewControllerDelegateProtocol: AnyObject {
    func didCreateTracker(_ tracker: Tracker, category: TrackerCategory)
}

final class NewTrackerViewController: UIViewController {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 16
        field.backgroundColor = .ypBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .red
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojisCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    weak var delegate: NewTrackerViewControllerDelegateProtocol?
    
    
    private let types = ["Категория", "Расписание"]
    private var selectedDays: Set<WeekDay> = []
    private let maximumSymbols = 38
    private var scheduleSubtitle: String?
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🌴", "😪"]
    private let colors = [#colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1), #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            
            textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojisCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojisCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojisCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: 220),
            
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 34),
            colorsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 220),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    private func setupUI() {
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textField)
        contentView.addSubview(textLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(emojisCollectionView)
        contentView.addSubview(colorsCollectionView)
        emojisCollectionView.isScrollEnabled = false
        colorsCollectionView.isScrollEnabled = false
    
        tableView.register(NewTrackerCell.self, forCellReuseIdentifier: NewTrackerCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.isEnabled = false
        emojisCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        colorsCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        emojisCollectionView.delegate = self
        emojisCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        emojisCollectionView.register(TrackerCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCollectionHeader.identifier)
        colorsCollectionView.register(TrackerCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCollectionHeader.identifier)
    }
    
    private func changeCreateButton() {
        let name = !(textField.text?.isEmpty ?? true)
        let days = !selectedDays.isEmpty
        let emoji = selectedEmojiIndex != nil
        let color = selectedColorIndex != nil
        createButton.isEnabled = name && days && emoji && color
        createButton.backgroundColor = name && days ? .ypBlack : .ypGray
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let name = textField.text, !name.isEmpty,
              let emoji = selectedEmoji,
              let color = selectedColor else { return }
        
        let tracker = Tracker(id: UUID(), name: name, emoji: emoji, color: color, schedule: Array(selectedDays))
        let category = TrackerCategory(title: "Первый", trackers: [tracker])
        delegate?.didCreateTracker(tracker, category: category)
        dismiss(animated: true)
    }
}

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTrackerCell.identifier, for: indexPath) as? NewTrackerCell else { return UITableViewCell() }
        
        if indexPath.row == 1 {
            cell.configure(title: types[indexPath.row], subtitle: scheduleSubtitle)
        } else {
            cell.configure(title: types[indexPath.row], subtitle: nil)
        }
        return cell
    }
    
    
}

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            present(scheduleVC, animated: true)
        }
    }
}

extension NewTrackerViewController: ScheduleViewControllerDelegateProtocol {
    func didSelectDays(_ days: Set<WeekDay>) {
        selectedDays = days
        let daysString = WeekDay.orderedCases
            .filter { days.contains($0) }
            .map { $0.shortTitle }
            .joined(separator: ", ")
        self.scheduleSubtitle = daysString
        tableView.reloadData()
        changeCreateButton()
    }
}

extension NewTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: range, with: string)
        return newText.count <= maximumSymbols
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        changeCreateButton()
    }
}

extension NewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojisCollectionView {
            return emojis.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell()}
            cell.configure(with: emojis[indexPath.row])
            return cell
        } else {
            guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell()}
            cell.configure(with: colors[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCollectionHeader.identifier, for: indexPath) as? TrackerCollectionHeader else { return UICollectionReusableView() }
        
        if collectionView == emojisCollectionView {
            header.configure(title: "Emoji")
        } else {
            header.configure(title: "Цвет")
        }
        return header
    }
    
}

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollectionView {
            if let previous = selectedEmojiIndex {
                let previousCell = collectionView.cellForItem(at: previous) as? EmojiCell
                previousCell?.contentView.backgroundColor = .clear
            }
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.contentView.backgroundColor = .ypLightGray
            selectedEmojiIndex = indexPath
            selectedEmoji = emojis[indexPath.row]
            changeCreateButton()
        } else {
            if let previous = selectedColorIndex {
                let previousCell = collectionView.cellForItem(at: previous) as? ColorCell
                previousCell?.layer.borderColor = UIColor.clear.cgColor
            }
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            cell?.layer.borderColor = colors[indexPath.row].withAlphaComponent(0.3).cgColor
            cell?.layer.borderWidth = 3
            selectedColorIndex = indexPath
            selectedColor = colors[indexPath.row]
            changeCreateButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
}
