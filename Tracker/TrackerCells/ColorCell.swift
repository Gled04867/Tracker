import UIKit

final class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    private var colorView = UIView()
    
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
        contentView.addSubview(colorView)
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor)
            ])
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
}
