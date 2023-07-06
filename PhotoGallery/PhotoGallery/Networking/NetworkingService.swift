import Foundation
import Alamofire

class NetworkingService {
    static let shared = NetworkingService()
    
    private init() {}
    
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/photos"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let photos = try decoder.decode([Photo].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchComments(for photoId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/photos/\(photoId)/comments"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let comments = try decoder.decode([Comment].self, from: data)
                    completion(.success(comments))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
