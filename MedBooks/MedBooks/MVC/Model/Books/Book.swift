//
//  Book.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import Foundation

public struct BookData: Codable {
    var numFound: Int
    var start: Int
    var numFoundExact: Bool
    var docs: [Book]?
    var num_found: Int
    var q: String
    var offset: Int?
}

public struct Book: Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case author = "author_name"
        case coverImageId = "cover_i"
        case ratingAvg = "ratings_average"
        case ratingCount = "ratings_count"
    }
    
    var title: String?
    var author: [String]?
    var coverImageId: Int?
    var ratingAvg: Double?
    var ratingCount: Int?
    
    func getAuthors() -> String {
        self.author?.reduce("", { $0.appending("\($0 != "" ? ", ": "" )\($1)") }) ?? ""
    }
}

