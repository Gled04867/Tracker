import UIKit

final class EmojiCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with emoji: String) {
        label.text = emoji
        label.font = .systemFont(ofSize: 32, weight: .bold)
    }
}
