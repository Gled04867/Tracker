import UIKit

final class TrackerCategoryHeader: UICollectionReusableView {
    
    let titleLabel = UILabel()
    
    static let identifier = "HeaderCellIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

