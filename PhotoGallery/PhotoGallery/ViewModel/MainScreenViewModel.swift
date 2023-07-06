import Foundation
import RxSwift
import RxCocoa
import Alamofire

class MainScreenViewModel {
    private let disposeBag = DisposeBag()
    
    private let photosSubject = BehaviorSubject<[Photo]>(value: [])
    
    var photos: Observable<[Photo]> {
        return photosSubject.asObservable()
    }
    
    func fetchPhotos() {
        let urlString = "https://jsonplaceholder.typicode.com/photos"
        
        AF.request(urlString).responseData { [weak self] response in
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let photos = try decoder.decode([Photo].self, from: data)
                self?.photosSubject.onNext(photos)
            } catch {
                print("Error decoding photos: \(error)")
            }
        }
    }
}
