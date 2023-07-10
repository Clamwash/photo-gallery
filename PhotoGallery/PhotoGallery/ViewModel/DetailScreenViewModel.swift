import Foundation
import RxSwift
import RxCocoa

class DetailScreenViewModel {
    let photo: Photo
    private let networkingService: NetworkingService
    
    private let commentsSubject = PublishSubject<[Comment]>()
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var comments: Observable<[Comment]> {
        return commentsSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    init(photo: Photo, networkingService: NetworkingService) {
        self.photo = photo
        self.networkingService = networkingService
        
        fetchComments()
    }
    
    func fetchComments() {
        isLoadingRelay.accept(true)

        networkingService.fetchComments(for: photo.id) { [weak self] result in
            switch result {
            case .success(let comments):
                self?.commentsSubject.onNext(comments)
            case .failure(let error):
                print("Error fetching comments: \(error)")
            }
            
            self?.isLoadingRelay.accept(false)
        }
    }
}
