import Foundation
import RxSwift
import RxCocoa

class DetailScreenViewModel {
    let photo: Photo
    private let networkingService: NetworkingService
    
    private let commentsSubject = PublishSubject<[Comment]>()
    
    var comments: Observable<[Comment]> {
        return commentsSubject.asObservable()
    }
    
    init(photo: Photo, networkingService: NetworkingService) {
        self.photo = photo
        self.networkingService = networkingService
        
        fetchComments(for: photo.id)
    }
    
    func fetchComments(for photoId: Int) {
        networkingService.fetchComments(for: photoId) { [weak self] result in
            switch result {
            case .success(let comments):
                self?.commentsSubject.onNext(comments)
            case .failure(let error):
                print("Error fetching comments: \(error)")
            }
        }
    }
}
