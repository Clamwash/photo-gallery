import UIKit
import PureLayout

class LaunchScreenViewController: UIViewController {
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        logoImageView = UIImageView.newAutoLayout()
        logoImageView.image = UIImage(named: "App-icon-move-01")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        titleLabel = UILabel.newAutoLayout()
        titleLabel.text = "iOS assignment: Photo gallery"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        logoImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        logoImageView.autoAlignAxis(.horizontal, toSameAxisOf: view, withOffset: -30)
        logoImageView.autoSetDimensions(to: CGSize(width: 350, height: 350))

        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(.top, to: .bottom, of: logoImageView, withOffset: 10)
    }
}
