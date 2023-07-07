import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class MainScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MainScreenViewModel
    private let networkingService: NetworkingService
    
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    init() {
        self.networkingService = NetworkingService.shared
        let viewModel = MainScreenViewModel(networkingService: networkingService)
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
        
        viewModel.fetchPhotos()
    }
    
    private func setupUI() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(MainScreenTableViewCell.self, forCellReuseIdentifier: "Cell")

        view.addSubview(tableView)
        
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
    }
    
    private func bindViewModel() {
        viewModel.photos
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, photo, cell in
                guard let cell = cell as? MainScreenTableViewCell else { return }
                
                cell.titleLabel.text = photo.title
                
                if let url = URL(string: photo.thumbnailUrl) {
                    cell.thumbnailImageView.af.setImage(withURL: url)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Photo.self)
            .subscribe(onNext: { [weak self] photo in
                self?.navigateToDetailScreen(photo: photo)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func navigateToDetailScreen(photo: Photo) {
        let detailViewModel = DetailScreenViewModel(photo: photo, networkingService: networkingService)
        let detailViewController = DetailScreenViewController(viewModel: detailViewModel)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
