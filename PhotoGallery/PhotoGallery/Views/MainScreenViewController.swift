import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage
import PureLayout

class MainScreenViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = MainScreenViewModel()
    
    private let tableView = UITableView()
    
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
    }
    
    private func navigateToDetailScreen(photo: Photo) {
        let detailViewModel = DetailScreenViewModel(photo: photo)
        let detailViewController = DetailScreenViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

class MainScreenTableViewCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.clipsToBounds = true
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        
        thumbnailImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        thumbnailImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        thumbnailImageView.autoSetDimensions(to: CGSize(width: 40, height: 40))
        
        titleLabel.autoPinEdge(.leading, to: .trailing, of: thumbnailImageView, withOffset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
}
