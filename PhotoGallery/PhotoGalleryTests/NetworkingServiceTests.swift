@testable import PhotoGallery
import XCTest

class NetworkingServiceTests: XCTestCase {
    var networkingService: NetworkingProtocol!
    
    override func setUp() {
        super.setUp()
        networkingService = MockNetworkingService()
    }
    
    override func tearDown() {
        networkingService = nil
        super.tearDown()
    }
    
    func testFetchPhotos() {
        networkingService.fetchPhotos { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, 1)
                XCTAssertEqual(photos.first?.title, "Test Photo")
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
    }
    
    func testFetchComments() {
        networkingService.fetchComments(for: 1) { result in
            switch result {
            case .success(let comments):
                XCTAssertEqual(comments.count, 1)
                XCTAssertEqual(comments.first?.name, "Test")
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
        }
    }
}
