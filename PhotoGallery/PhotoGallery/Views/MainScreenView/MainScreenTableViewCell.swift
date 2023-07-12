import Foundation
import UIKit
import PureLayout

class MainScreenTableViewCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        thumbnailImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        thumbnailImageView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        
        titleLabel.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        titleLabel.numberOfLines = 0
    }
}
