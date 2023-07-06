import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MainScreenViewModel()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
    }
    
    private func bindViewModel() {
        viewModel.photos
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, photo, cell in
                cell.textLabel?.text = photo.title
            }
            .disposed(by: disposeBag)
    }
}
