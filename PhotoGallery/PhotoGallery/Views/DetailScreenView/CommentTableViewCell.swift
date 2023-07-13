import UIKit
import PureLayout

class CommentTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let bodyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        nameLabel.font = UIFont.boldSystemFont(ofSize: Constants.CGFloats.medium)
        emailLabel.font = Constants.Fonts.mediumItalic
        bodyLabel.font = Constants.Fonts.medium
        bodyLabel.numberOfLines = 0
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(bodyLabel)
        
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.CGFloats.small)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.CGFloats.medium)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: Constants.CGFloats.xsmall)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.CGFloats.medium)
        emailLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        emailLabel.textColor = .gray
        
        bodyLabel.autoPinEdge(.top, to: .bottom, of: emailLabel, withOffset: Constants.CGFloats.xsmall)
        bodyLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.CGFloats.medium)
        bodyLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        bodyLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.CGFloats.small)
    }
    
    func configure(with comment: Comment) {
        nameLabel.text = comment.name
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
    }
}
