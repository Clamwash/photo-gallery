import UIKit
import PureLayout
import RxSwift
import RxCocoa
import Alamofire

class DetailScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: DetailScreenViewModel
    
    private let titleLabel = UILabel()
    private let photoImageView = UIImageView()
    private var latestBookDetail: BookDetail?
    private let commentsTableView = UITableView()
    private let headerView = UIView()

    
    private let photoImageHeight: CGFloat = 250
    private let headerViewHeight: CGFloat = 300
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: DetailScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        loadPhoto()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        commentsTableView.tableHeaderView = headerView
    }
    
    private func setupUI() {
        commentsTableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionTableViewCell")
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")

        titleLabel.text = viewModel.book.title
        titleLabel.numberOfLines = 0
        titleLabel.accessibilityIdentifier = Constants.Strings.DetailScreen.accessibilityIdentifier
        titleLabel.textAlignment = .center
        titleLabel.font = Constants.Fonts.largeBold
        
        view.backgroundColor = .white
                
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = .lightGray
        
        photoImageView.autoSetDimension(.height, toSize: photoImageHeight)
        photoImageView.layer.cornerRadius = Constants.CGFloats.medium
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerViewHeight)
        headerView.addSubview(titleLabel)
        headerView.addSubview(photoImageView)
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: Constants.CGFloats.medium)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: Constants.CGFloats.medium)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: Constants.CGFloats.medium)
        
        photoImageView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: Constants.CGFloats.medium)
        photoImageView.autoPinEdge(toSuperviewEdge: .leading)
        photoImageView.autoPinEdge(toSuperviewEdge: .trailing)
        photoImageView.autoPinEdge(toSuperviewEdge: .bottom)
        
        
        view.addSubview(commentsTableView)
        
        commentsTableView.autoPinEdgesToSuperviewEdges()
        
        headerView.layoutIfNeeded()

        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.autoCenterInSuperview()
        
        commentsTableView.refreshControl = refreshControl
    }



    
    private func bindViewModel() {
//        viewModel.booksByTheAuthor
//            .bind(to: commentsTableView.rx.items(cellIdentifier: "CommentCell")) { index, book, cell in
//                guard let cell = cell as? CommentTableViewCell else { return }
//                cell.configure(with: book)
//            }
//            .disposed(by: disposeBag)
        
        viewModel.booksByTheAuthor.bind(to: commentsTableView.rx.items) { (tableView, index, book) in
            let cellIdentifier = index == 0 ? "DescriptionTableViewCell" : "CommentCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: IndexPath(row: index, section: 0))
            
            if index == 0, let descriptionViewCell = cell as? DescriptionTableViewCell {
                let descriptionText = self.latestBookDetail?.description?.compactMap { $0.value }.joined(separator: "\n")
                
                descriptionViewCell.descriptionLabel.text = descriptionText
                
                return descriptionViewCell
            }
            
            if let tableViewCell = cell as? CommentTableViewCell {
                tableViewCell.configure(with: book)
            }
            return cell
        }
        .disposed(by: disposeBag)
        
        viewModel.bookDetails
            .subscribe(onNext: { [weak self] bookDetail in
                self?.latestBookDetail = bookDetail
            })
            .disposed(by: disposeBag)
        
        commentsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.commentsTableView.cellForRow(at: indexPath) as? DescriptionTableViewCell else { return }
                cell.descriptionLabel.numberOfLines = cell.descriptionLabel.numberOfLines == 0 ? 4 : 0
                
//                self?.commentsTableView.rowHeight = UITableView.automaticDimension

                self?.commentsTableView.beginUpdates()
                      self?.commentsTableView.endUpdates()
            })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchBooksByTheAuthor()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.refreshControl.beginRefreshing()
                } else {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadPhoto() {
        if let bookCoverId = viewModel.book.coverEditionKey {
            let bookCoverUrl = "https://covers.openlibrary.org/b/olid/\(bookCoverId)-M.jpg"
            
            if let url = URL(string: bookCoverUrl) {
                self.photoImageView.af.setImage(withURL: url)
            }
        }
    }
}
