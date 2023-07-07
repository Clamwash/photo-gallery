import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    private let networkingService: NetworkingService
    
    private let photosSubject = BehaviorSubject<[Photo]>(value: [])
    
    var photos: Observable<[Photo]> {
        return photosSubject.asObservable()
    }
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func fetchPhotos() {
        networkingService.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photosSubject.onNext(photos)
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }
    }
}
