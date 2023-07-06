import UIKit
import RxSwift
import RxCocoa

class DetailScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: DetailScreenViewModel
    
    private let tableView = UITableView()
    
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
    }
    
    private func setupUI() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        
        view.addSubview(tableView)
    }
    
    private func bindViewModel() {
        viewModel.comments
            .bind(to: tableView.rx.items(cellIdentifier: "CommentCell")) { index, comment, cell in
                cell.textLabel?.text = comment
            }
            .disposed(by: disposeBag)
    }
}
