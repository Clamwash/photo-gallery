import UIKit
import PureLayout

class DescriptionTableViewCell: UITableViewCell {
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.selectionStyle = .none
        descriptionLabel.numberOfLines = 4
        
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.CGFloats.medium)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Constants.CGFloats.medium)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Constants.CGFloats.medium)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.CGFloats.medium)
    }
}

