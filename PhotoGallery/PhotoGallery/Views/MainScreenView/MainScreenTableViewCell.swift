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
        thumbnailImageView.layer.cornerRadius = 8
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        thumbnailImageView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        
        titleLabel.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
}
