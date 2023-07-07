import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    private let networkingService: NetworkingService
    
    private let photosSubject = BehaviorSubject<[Photo]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)

    
    var photos: Observable<[Photo]> {
        return photosSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func fetchPhotos() {
        isLoadingRelay.accept(true)
        
        networkingService.fetchPhotos { [weak self] result in
            defer {
                self?.isLoadingRelay.accept(false)
            }
            
            switch result {
            case .success(let photos):
                self?.photosSubject.onNext(photos)
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }
    }
}
