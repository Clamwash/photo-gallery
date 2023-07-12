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
    private let commentsTableView = UITableView()
    private let photoImageHeight: CGFloat = 250
    
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
    
    private func setupUI() {
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
        titleLabel.text = viewModel.photo.title
        titleLabel.numberOfLines = 0
        
        view.backgroundColor = .white
        
        // Configure photo title label
        titleLabel.textAlignment = .center
        titleLabel.font = Constants.Fonts.largeBold
        
        view.addSubview(titleLabel)
        
        // Configure photo image view
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = .lightGray
        
        view.addSubview(photoImageView)
        
        // Constraints for title label
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: Constants.CGFloats.medium)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        // Constraints for photo image view
        photoImageView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: Constants.CGFloats.medium)
        photoImageView.autoPinEdge(toSuperviewEdge: .leading)
        photoImageView.autoPinEdge(toSuperviewEdge: .trailing)
        photoImageView.autoSetDimension(.height, toSize: photoImageHeight)
        photoImageView.layer.cornerRadius = Constants.CGFloats.medium
        
//        commentsTableView.backgroundColor = .clear
        
        view.addSubview(commentsTableView)
        
        // Constraints for comments table view
        commentsTableView.autoPinEdge(.top, to: .bottom, of: photoImageView, withOffset: Constants.CGFloats.medium)
        commentsTableView.autoPinEdge(toSuperviewEdge: .leading)
        commentsTableView.autoPinEdge(toSuperviewEdge: .trailing)
        commentsTableView.autoPinEdge(toSuperviewSafeArea: .bottom)
                
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        
        commentsTableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel.comments
            .map { Array($0.prefix(20)) }
            .bind(to: commentsTableView.rx.items(cellIdentifier: "CommentCell")) { index, comment, cell in
                guard let cell = cell as? CommentTableViewCell else { return }
                cell.configure(with: comment)
            }
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchComments()
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
        let photoUrl = viewModel.photo.url
        
        if let url = URL(string: photoUrl) {
            self.photoImageView.af.setImage(withURL: url)
        }
    }
}
