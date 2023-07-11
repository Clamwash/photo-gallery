import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    private let networkingService: NetworkingService
    
    private let photosSubject = BehaviorSubject<[Photo]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let alertRelay = PublishRelay<String>()

    var photos: Observable<[Photo]> {
        return photosSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    var alert: Observable<String> {
        return alertRelay.asObservable()
    }
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func fetchPhotos() {
        isLoadingRelay.accept(true)
        
        networkingService.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photosSubject.onNext(photos)
            case .failure(let error):
                let errorMessage = "Failed to fetch photos. Please check your internet connection."
                self?.alertRelay.accept(errorMessage)
                print("Error fetching photos: \(error)")
            }
            
            self?.isLoadingRelay.accept(false)
        }
    }
}
