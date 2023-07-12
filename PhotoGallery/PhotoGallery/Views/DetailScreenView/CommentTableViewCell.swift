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
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.font = UIFont.italicSystemFont(ofSize: 14)
        bodyLabel.font = UIFont.systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(bodyLabel)
        
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        
        emailLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 4)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        emailLabel.textColor = .gray
        
        bodyLabel.autoPinEdge(.top, to: .bottom, of: emailLabel, withOffset: 4)
        bodyLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        bodyLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        bodyLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
    }
    
    func configure(with comment: Comment) {
        nameLabel.text = comment.name
        emailLabel.text = comment.email
        bodyLabel.text = comment.body
    }
}
