import UIKit
import PureLayout

class CommentTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let authorLabel = UILabel()
    private let subject = UILabel()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView.newAutoLayout()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        authorLabel.font = Constants.Fonts.mediumItalic
        subject.font = Constants.Fonts.medium
        subject.numberOfLines = 0
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(subject)
        
        thumbnailImageView.autoSetDimensions(to: CGSize(width: 60, height: 60))
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.CGFloats.small)
        thumbnailImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        nameLabel.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: Constants.CGFloats.small)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.CGFloats.small)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        
        authorLabel.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: Constants.CGFloats.small)
        authorLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: Constants.CGFloats.xsmall)
        authorLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        authorLabel.textColor = .gray
        
        subject.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: Constants.CGFloats.small)
        subject.autoPinEdge(.top, to: .bottom, of: authorLabel, withOffset: Constants.CGFloats.xsmall)
        subject.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        subject.autoPinEdge(toSuperviewEdge: .bottom, withInset: Constants.CGFloats.small)
    }
    
    func configure(with book: Book) {
        nameLabel.text = book.title
        authorLabel.text = book.authorName?.first
        subject.text = book.subject?.first

        if let coverID = book.coverI {
            let imageURL = URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-S.jpg")
            if let url = imageURL {
                thumbnailImageView.af.setImage(withURL: url)
            }
        }
    }
}
