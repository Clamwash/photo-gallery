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
        commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        titleLabel.text = viewModel.photo.title
        
        view.backgroundColor = .white
        
        // Configure photo title label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(titleLabel)
        
        // Configure photo image view
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = .lightGray
        
        view.addSubview(photoImageView)
        
        // Constraints for title label
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        // Constraints for photo image view
        photoImageView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        photoImageView.autoPinEdge(toSuperviewEdge: .leading)
        photoImageView.autoPinEdge(toSuperviewEdge: .trailing)
        photoImageView.autoSetDimension(.height, toSize: 200)
        
//        commentsTableView.backgroundColor = .clear
        
        view.addSubview(commentsTableView)
        
        // Constraints for comments table view
        commentsTableView.autoPinEdge(.top, to: .bottom, of: photoImageView, withOffset: 16)
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
            .bind(to: commentsTableView.rx.items(cellIdentifier: "CommentCell")) { _, comment, cell in
                cell.textLabel?.text = comment.body
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
