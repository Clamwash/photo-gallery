import UIKit
import PureLayout

class LaunchScreenViewController: UIViewController {
    private let logoImageSize = CGSize(width: 350, height: 350)
    
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        logoImageView = UIImageView.newAutoLayout()
        logoImageView.image = UIImage(named: Constants.Strings.LaunchScreen.appIconTitle)
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        titleLabel = UILabel.newAutoLayout()
        titleLabel.text = Constants.Strings.LaunchScreen.title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        
        logoImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        logoImageView.autoAlignAxis(.horizontal, toSameAxisOf: view, withOffset: -30)
        logoImageView.autoSetDimensions(to: logoImageSize)

        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(.top, to: .bottom, of: logoImageView, withOffset: Constants.CGFloats.small)
    }
}
