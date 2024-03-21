//
//  Forum.swift
//  Comet Sports
//
//  Created by iosDev on 28/02/2024.
//

import Foundation

struct ForumListResponse: Codable {
    let response: ForumList?
    let error: ForumList?
}

struct ForumList: Codable {
    let code: Int?
    let messages: [String]?
    let data: [Forum]?
}

struct JoinedForumResponse: Codable {
    let response: JoinedForumList?
    let error: JoinedForumList?
}

struct JoinedForumList: Codable {
    let code: Int?
    let messages: [String]?
    let data: [JoinedForum]?
}

struct JoinedForum: Codable {
    var forum = Forum()
}

struct ForumResponse: Codable {
    let response: ForumData?
    let error: ForumData?
}

struct ForumData: Codable {
    let code: Int?
    let messages: [String]?
    let data: Forum?
}

struct Forum: Codable {
    var id: Int = 0
    var title: String = ""
    var body: String = ""
    var forumUniqueID: String = ""
    var coverImageURL: String = ""
    var coverImage2: String = ""
    var postList: [Post] = []
    var hasJoined: Bool = false
    
    var haveImage = false
    

    enum CodingKeys: String, CodingKey {
        case id, title, body, hasJoined
        case forumUniqueID = "forum_unique_id"
        case coverImageURL = "cover_image_url"
        case coverImage2 = "cover_img_url"
    }
    init () {}
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        body = try (container.decodeIfPresent(String.self, forKey: .body) ?? "")
        forumUniqueID = try (container.decodeIfPresent(String.self, forKey: .forumUniqueID) ?? "")
        coverImageURL = try (container.decodeIfPresent(String.self, forKey: .coverImageURL) ?? "")
        coverImage2 = try (container.decodeIfPresent(String.self, forKey: .coverImage2) ?? "")
        if coverImageURL == "" {
            coverImageURL = coverImage2
        }
        hasJoined = try (container.decodeIfPresent(Bool.self, forKey: .hasJoined) ?? false)
    }
}
