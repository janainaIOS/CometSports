//
//  User.swift
//  Comet Sports
//
//  Created by iosDev on 13/02/2024.
//

import UIKit

struct UserResponse: Codable {
    let response: UserData?
    let error: UserData?
}

struct UserData: Codable {
    let code: Int?
    let messages: [String]?
    let data: User?
}

struct User: Codable {
    var id: Int? = 0
    var fullName: String = ""
    var email: String = ""
    var image: String = ""
    var image2: String = ""
    var token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, email, token
        case fullName = "full_name"
        case image = "profile_image"
        case image2 = "profile_img"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        email = try (container.decodeIfPresent(String.self, forKey: .email) ?? "")
        fullName = try (container.decodeIfPresent(String.self, forKey: .fullName) ?? "")
        image = try (container.decodeIfPresent(String.self, forKey: .image) ?? "")
        image2 = try (container.decodeIfPresent(String.self, forKey: .image2) ?? "")
        if image == "" {
            image = image2
        }
        token = try (container.decodeIfPresent(String.self, forKey: .token) ?? "")
    }
}

struct ProfileResponse: Codable {
    let response: ProfileData?
    let error: ProfileData?
}

struct ProfileData: Codable {
    let code: Int?
    let messages: String?
    let data: User?
}

struct BasicResponse: Codable {
    let response: BasicData?
    let error: BasicData?
}

struct BasicData: Codable {
    let code: Int?
    let messages: [String]?
}

struct BasicResponse2: Codable {
    let response: BasicData2?
    let error: BasicData2?
}

struct BasicData2: Codable {
    let code: Int?
    let messages: String?
}

