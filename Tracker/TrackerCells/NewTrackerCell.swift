import UIKit

final class NewTrackerCell: UITableViewCell {
    static let identifier = "NewTrackerCell"
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    private var titleLabelCenterYConstraint: NSLayoutConstraint?
    private var titleLabelTopConstraint: NSLayoutConstraint?
    let chevron = UIImageView(image: UIImage(systemName: SystemImages.chevronRight))
    
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
        contentView.addSubview(subtitleLabel)
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .ypBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = .ypGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .ypGray
        accessoryView = chevron
        backgroundColor = .ypBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        titleLabelCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        titleLabelCenterYConstraint?.isActive = true
    }
    
    func configure(title: String, subtitle: String?) {
        titleLabel.text = title
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
            titleLabelCenterYConstraint?.isActive = false
            titleLabelTopConstraint?.isActive = true
        } else {
            subtitleLabel.isHidden = true
            titleLabelTopConstraint?.isActive = false
            titleLabelCenterYConstraint?.isActive = true
        }
    }
}
