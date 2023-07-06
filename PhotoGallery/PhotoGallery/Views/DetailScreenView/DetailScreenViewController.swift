import UIKit
import PureLayout
import RxSwift
import RxCocoa

class DetailScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: DetailScreenViewModel
    
    private let photoImageView = UIImageView()
    private let commentsTableView = UITableView()
    
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
        
        view.backgroundColor = .white
        
        // Configure photo image view
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.backgroundColor = .lightGray
        
        view.addSubview(photoImageView)
        
        // Constraints for photo image view
        photoImageView.autoPinEdge(toSuperviewSafeArea: .top)
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
        
//        commentsTableView.isScrollEnabled = false
    }
    
    private func bindViewModel() {
        viewModel.comments
            .bind(to: commentsTableView.rx.items(cellIdentifier: "CommentCell")) { _, comment, cell in
                cell.textLabel?.text = comment
            }
            .disposed(by: disposeBag)
    }
    
    private func loadPhoto() {
        let photoImage = UIImage(named: "sample-photo")
        photoImageView.image = photoImage
    }
}
