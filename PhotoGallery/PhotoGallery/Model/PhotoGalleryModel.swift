import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

struct Books: Codable {
    let works: [Book]?
    let docs: [Book]?
}

struct Book: Codable {
    let key: String?
    let title: String?
    let editionCount: Int?
    let firstPublishYear: Int?
    let hasFulltext: Bool?
    let publicScanB: Bool?
    let coverEditionKey: String?
    let coverI: Int?
    let language: [String]?
    let authorKey: [String]?
    let authorName: [String]?
    let subject: [String]?

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case editionCount = "edition_count"
        case firstPublishYear = "first_publish_year"
        case hasFulltext = "has_fulltext"
        case publicScanB = "public_scan_b"
        case coverEditionKey = "cover_edition_key"
        case coverI = "cover_i"
        case language
        case authorKey = "author_key"
        case authorName = "author_name"
        case subject
    }
}

struct BookDetail: Codable {
    let description: [Description]?
    
    enum CodingKeys: String, CodingKey {
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let descriptionString = try? container.decode(String.self, forKey: .description) {
            description = [Description(type: "", value: descriptionString)]
        } else if let descriptionDict = try? container.decode([String: String].self, forKey: .description) {
            let descriptionValue = descriptionDict["value"] ?? ""
            description = [Description(type: "", value: descriptionValue)]
        } else if let descriptionArray = try? container.decode([Description].self, forKey: .description) {
            description = descriptionArray
        } else {
            description = nil
        }
    }
}

struct Description: Codable {
    let type: String
    let value: String
}
