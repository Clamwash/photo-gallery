import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var networkingService: NetworkingProtocol

    override init() {
        self.networkingService = NetworkingService()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let launchScreenVC = LaunchScreenViewController()

        window?.rootViewController = launchScreenVC
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            let navigationController = UINavigationController(rootViewController: MainScreenViewController(networkingService: networkingService))
            self.window?.rootViewController = navigationController
        }
        
        return true
    }
}

