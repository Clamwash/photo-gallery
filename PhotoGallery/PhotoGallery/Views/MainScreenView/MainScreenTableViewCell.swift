import Foundation
import UIKit
import PureLayout

class MainScreenTableViewCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    
    private let imageSize = CGSize(width: 80, height: 80)
    
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
        thumbnailImageView.layer.cornerRadius = Constants.CGFloats.small
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.CGFloats.small)
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.CGFloats.medium)
        thumbnailImageView.autoSetDimensions(to: imageSize)
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.CGFloats.small)
        
        titleLabel.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: Constants.CGFloats.small)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
}
