@testable import PhotoGallery

class MockNetworkingService: NetworkingProtocol {
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let photo = Photo(albumId: 1, id: 1, title: "Test Photo", url: "https://test.com", thumbnailUrl: "https://test.com")
        completion(.success([photo]))
    }
    
    func fetchComments(for photoId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let comment = Comment(postId: 1, id: 1, name: "Test", email: "test@test.com", body: "Test Comment")
        completion(.success([comment]))
    }
}
