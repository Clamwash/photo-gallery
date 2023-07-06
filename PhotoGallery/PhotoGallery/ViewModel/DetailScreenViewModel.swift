import Foundation
import RxSwift
import RxCocoa

class DetailScreenViewModel {
    let photo: Photo
    
    private let commentsSubject = BehaviorSubject<[String]>(value: [])
    
    var comments: Observable<[String]> {
        return commentsSubject.asObservable()
    }
    
    init(photo: Photo) {
        self.photo = photo
        
        fetchComments()
    }
    
    private func fetchComments() {
        let comments = [
            "Comment 1",
            "Comment 2",
            "Comment 3"
        ]
        
        commentsSubject.onNext(comments)
    }
}
