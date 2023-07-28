import Foundation
import Alamofire

protocol NetworkingProtocol {
    func fetchBooks(completion: @escaping (Result<Books, Error>) -> Void)
    func fetchBooksByTheAuthor(for authorName: String?, completion: @escaping (Result<Books, Error>) -> Void)
    func fetchBookDetails(for key: String, completion: @escaping (Result<BookDetail, Error>) -> Void)
}

class NetworkingService: NetworkingProtocol {
    func fetchBooks(completion: @escaping (Result<Books, Error>) -> Void) {
        let urlString = "https://openlibrary.org/trending/daily.json"

        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let books = try decoder.decode(Books.self, from: data)
                    completion(.success(books))
                } catch {
                    completion(.failure(error))
                    print(error)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBookDetails(for key: String, completion: @escaping (Result<BookDetail, Error>) -> Void) {
        let urlString = "https://openlibrary.org/\(key).json"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let book = try decoder.decode(BookDetail.self, from: data)
                    completion(.success(book))
                } catch {
                    completion(.failure(error))
                    print(error)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBooksByTheAuthor(for authorName: String?, completion: @escaping (Result<Books, Error>) -> Void) {
        guard let authorName = authorName,
              let encodedAuthorName = authorName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else { return }
        
        let urlString = "https://openlibrary.org/search.json?author=\(encodedAuthorName)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let books = try decoder.decode(Books.self, from: data)
                    completion(.success(books))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
