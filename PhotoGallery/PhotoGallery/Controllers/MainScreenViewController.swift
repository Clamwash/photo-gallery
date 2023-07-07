import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MainScreenViewModel()
    
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
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
                cell.textLabel?.text = photo.title
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
        let detailViewModel = DetailScreenViewModel(photo: photo)
        let detailViewController = DetailScreenViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
