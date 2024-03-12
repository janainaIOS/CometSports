//
//  Banner.swift
//  Comet Sports
//
//  Created by iosDev on 15/02/2024.
//

import Foundation

struct BannerResponse: Decodable {
    let data: BannerData
}

struct BannerData: Decodable {
    let top: [Banner]
}

struct Banner: Decodable {
    let id, title, coverPath, thumbnailPath: String
    let message, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverPath = "cover_path"
        case thumbnailPath = "thumbnail_path"
        case message
        case createdAt = "created_at"
    }
}
