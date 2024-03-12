//
//  Post.swift
//  Comet Sports
//
//  Created by iosDev on 17/02/2024.
//

import Foundation

struct PostListResponse: Codable {
    let response: PostList?
    let error: PostList?
}

struct PostResponse: Codable {
    let response: PostData?
    let error: PostData?
}

struct PostList: Codable {
    let code: Int?
    let messages: [String]?
    let data: [Post]?
}

struct PostData: Codable {
    let code: Int?
    let messages: [String]?
    let data: Post?
}

struct Post: Codable {
    let id: Int?
    let title, contentHTML: String?
    let isVisible, forumID, creatorUserID: Int?
    let createdAt, updatedAt: String?
    let user: User?
    let postImages: [PostImage]?
    let likeCount, commentCount: Int?
    let isLiked: Bool?
    let forumName: String?
    var forumUniqueID: String?
    let isBlocked: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title
        case contentHTML = "content_html"
        case isVisible = "is_visible"
        case forumID = "forum_id"
        case creatorUserID = "creator_user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case postImages = "post_images"
        case likeCount, commentCount, isLiked
        case forumUniqueID = "forum_unique_id"
        case forumName = "forum_name"
        case isBlocked
    }
}

struct ImageResponse: Codable {
    let response: ImageData?
    let error: ImageData?
}

struct ImageData: Codable {
    let code: Int?
    let messages: String?
    let data: PostImage?
}

struct PostImage: Codable {
    let id: Int
    let url: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id, url
        case profileImage = "profile_image"
    }
}
