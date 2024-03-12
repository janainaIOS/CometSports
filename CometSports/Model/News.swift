//
//  News.swift
//  Comet Sports
//
//  Created by iosDev on 28/07/2023.
//

import Foundation

struct NewsResponse: Codable {
    var list: [News] = []
}

struct News: Codable {
    var id: Int = 0
    var date: String = ""
    var title: String = ""
    var descriptn: String = ""
    var content: String = ""
    var path: String = ""

    enum CodingKeys: String, CodingKey {
        case id, title, content, path
        case date = "create_time"
        case descriptn = "description"
    }
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        date = try (container.decodeIfPresent(String.self, forKey: .date) ?? "")
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        descriptn = try (container.decodeIfPresent(String.self, forKey: .descriptn) ?? "")
        content = try (container.decodeIfPresent(String.self, forKey: .content) ?? "")
        path = try (container.decodeIfPresent(String.self, forKey: .path) ?? "")
    }
}
