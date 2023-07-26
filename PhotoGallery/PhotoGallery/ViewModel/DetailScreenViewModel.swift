import Foundation
import RxSwift
import RxCocoa

class DetailScreenViewModel {
    let book: Book
    private let networkingService: NetworkingProtocol
    
    private let booksByTheAuthorSubject = PublishSubject<[Book]>()
    private let bookDetailsSubject = PublishSubject<BookDetail>()

    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var booksByTheAuthor: Observable<[Book]> {
        return booksByTheAuthorSubject.asObservable()
    }
    
    var bookDetails: Observable<BookDetail> {
        return bookDetailsSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    
    init(book: Book, networkingService: NetworkingProtocol) {
        self.book = book
        self.networkingService = networkingService
        
        fetchBooksByTheAuthor()
        fetchBookDetails()
    }
    
    func fetchBookDetails() {
        networkingService.fetchBookDetails(for: book.key ?? "") { [weak self] result in
            switch result {
            case .success(let bookDetail):
                self?.bookDetailsSubject.onNext(bookDetail)
            case .failure(let error):
                print("Error fetching book details: \(error)")
            }
        }
    }
    
    func fetchBooksByTheAuthor() {
        isLoadingRelay.accept(true)

        networkingService.fetchBooksByTheAuthor(for: book.authorName?.first) { [weak self] result in
            switch result {
            case .success(let books):
                self?.booksByTheAuthorSubject.onNext(books.docs ?? [])
            case .failure(let error):
                print("Error fetching comments: \(error)")
            }

            self?.isLoadingRelay.accept(false)
        }
    }
}
