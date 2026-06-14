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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapDoneButton() {
        guard let tracker = tracker else { return }
        delegate?.didTapDoneButton(for: tracker)
    }
    
    private func setupButton() {
        doneButton.layer.cornerRadius = 17
        doneButton.setImage(UIImage(systemName: "plus"), for: .normal)
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
        nameLabel.textColor = .white
        updateDoneButton(isCompleted: isCompleted, date: date)
        self.tracker = tracker
        daysLabel.text = "\(daysCount) дней"
        
    }
    
    private func updateDoneButton(isCompleted: Bool, date: Date) {
        let today = Calendar.current.startOfDay(for: Date())
        let selected = Calendar.current.startOfDay(for: date)
        doneButton.isEnabled = selected <= today
        let image = isCompleted ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        doneButton.setImage(image, for: .normal)
    }
}
