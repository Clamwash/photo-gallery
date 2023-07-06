import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {
    private let disposeBag = DisposeBag()
    
    private let photosSubject = BehaviorSubject<[Photo]>(value: [])
    
    var photos: Observable<[Photo]> {
        return photosSubject.asObservable()
    }
    
    init() {
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        let photos = [
            Photo(title: "Photo 1", thumbnail: "thumbnail_1.jpg"),
            Photo(title: "Photo 2", thumbnail: "thumbnail_2.jpg"),
            Photo(title: "Photo 3", thumbnail: "thumbnail_3.jpg")
        ]
        
        photosSubject.onNext(photos)
    }
}
