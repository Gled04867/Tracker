import UIKit

protocol TrackerCellDelegateProtocol: AnyObject {
    func didTapDoneButton(for tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    let emojiLabel = UILabel()
    let nameLabel = UILabel()
    let colorView = UIView()
    let daysLabel = UILabel()
    let doneButton = UIButton()
    
    private var tracker: Tracker?
    
    weak var delegate: TrackerCellDelegateProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func didTapDoneButton() {
        guard let tracker = tracker else { return }
        delegate?.didTapDoneButton(for: tracker)
    }
    
    private func setupButton() {
        doneButton.layer.cornerRadius = 17
        doneButton.setImage(UIImage(systemName: SystemImages.plus), for: .normal)
        doneButton.tintColor = .white
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    private func setupViews() {
        
        contentView.layer.cornerRadius = 16
        colorView.layer.cornerRadius = 16
        colorView.layer.masksToBounds = true
        contentView.layer.masksToBounds = true
                
        contentView.addSubview(colorView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(doneButton)
        colorView.addSubview(emojiLabel)
        colorView.addSubview(nameLabel)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            colorView.heightAnchor.constraint(equalToConstant: 90),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 14),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 14),
            
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            daysLabel.widthAnchor.constraint(equalToConstant: 101)
            
            ])
    }
    
    func configureCell(tracker: Tracker, isCompleted: Bool, date: Date, daysCount: Int) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        colorView.backgroundColor = tracker.color
        doneButton.backgroundColor = tracker.color
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .white
        updateDoneButton(isCompleted: isCompleted, date: date)
        self.tracker = tracker
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = .ypBlack
        daysLabel.text = daysString(daysCount)
        
    }
    
    private func updateDoneButton(isCompleted: Bool, date: Date) {
        let today = Calendar.current.startOfDay(for: Date())
        let selected = Calendar.current.startOfDay(for: date)
        doneButton.isEnabled = selected <= today
        let image = isCompleted ? UIImage(systemName: SystemImages.checkmark) : UIImage(systemName: SystemImages.plus)
        doneButton.setImage(image, for: .normal)
    }
    
    private func daysString(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "\(count) дней"
        }
        switch remainder10 {
        case 1: return "\(count) день"
        case 2, 3, 4: return "\(count) дня"
        default: return "\(count) дней"
        }
    }
}
