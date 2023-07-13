import UIKit

struct Constants {
    struct CGFloats {
        static let xsmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
    }
    
    struct Fonts {
        static let medium = UIFont.systemFont(ofSize: 14)
        static let mediumItalic = UIFont.italicSystemFont(ofSize: 14)
        
        static let largeBold = UIFont.boldSystemFont(ofSize: 20)
    }
}

extension Constants {
    struct Strings {
        struct LaunchScreen {
            static let appIconTitle = "App-icon-move-01"
            
            static let title = "iOS assignment: Photo gallery"
        }
        
        struct MainScreen {
            static let accessibilityIdentifier = "MainScreenTitleLabel"

            static let errorText = "Failed to fetch photos. Please check your internet connection."
        }
        
        struct DetailScreen {
            static let accessibilityIdentifier = "DetailScreenTitleLabel"
        }
    }
}
