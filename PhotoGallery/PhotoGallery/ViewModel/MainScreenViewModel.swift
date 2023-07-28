import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    private let networkingService: NetworkingProtocol
    private let booksSubject = BehaviorSubject<[Book]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let alertRelay = PublishRelay<String>()

    var books: Observable<[Book]> {
        return booksSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    var alert: Observable<String> {
        return alertRelay.asObservable()
    }
    
    init(networkingService: NetworkingProtocol) {
        self.networkingService = networkingService
    }
    
    func fetchBooks() {
        isLoadingRelay.accept(true)
        
        networkingService.fetchBooks { [weak self] result in
            switch result {
            case .success(let books):
                self?.booksSubject.onNext(books.works ?? [])
            case .failure(_):
                let errorMessage = Constants.Strings.MainScreen.errorText
                self?.alertRelay.accept(errorMessage)
            }
            
            self?.isLoadingRelay.accept(false)
        }
    }
}
