//
//  Comment.swift
//  Comet Sports
//
//  Created by iosDev on 24/02/2024.
//

import Foundation

struct CommentResponse: Codable {
    let response: CommentData?
    let error: CommentData?
}

struct CommentData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [Comment]?
}

struct Comment: Codable {
    var id: Int = 0
    var sectionId: String = ""
    var updatedTime: String = ""
    var createdTime: String = ""
    var comment: String = ""
    var user = User()
    
    enum CodingKeys: String, CodingKey {
        case id, comment, user
        case sectionId = "comment_section_id"
        case updatedTime = "updated_at"
        case createdTime = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        sectionId = try (container.decodeIfPresent(String.self, forKey: .sectionId) ?? "")
        updatedTime = try (container.decodeIfPresent(String.self, forKey: .updatedTime) ?? "")
        createdTime = try (container.decodeIfPresent(String.self, forKey: .createdTime) ?? "")
        comment = try (container.decodeIfPresent(String.self, forKey: .comment) ?? "")
        user = try (container.decodeIfPresent(User.self, forKey: .user) ?? User())
    }
}
