import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

class MainScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MainScreenViewModel
    private let networkingService: NetworkingProtocol
    
    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let imageView = UIImageView()
    
    init(networkingService: NetworkingProtocol) {
        self.networkingService = networkingService
        
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
        
        viewModel.fetchBooks()
    }
    
    private func setupUI() {
        tableView.register(MainScreenTableViewCell.self, forCellReuseIdentifier: "Cell")

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        
        tableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel.books
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, book, cell in
                guard let cell = cell as? MainScreenTableViewCell else { return }
                
                cell.titleLabel.text = book.title
                
                if let bookCoverId = book.coverEditionKey {
                    let bookCoverUrl = "https://covers.openlibrary.org/b/olid/\(bookCoverId)-M.jpg"

                    
                    if let url = URL(string: bookCoverUrl) {
                        cell.thumbnailImageView.af.setImage(withURL: url)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [weak self] book in
                self?.navigateToDetailScreen(book: book)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchBooks()
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
        
        viewModel.alert
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToDetailScreen(book: Book) {
        let detailViewModel = DetailScreenViewModel(book: book, networkingService: networkingService)
        let detailViewController = DetailScreenViewController(viewModel: detailViewModel)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainScreenViewController {
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
