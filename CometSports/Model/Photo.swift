//
//  Photo.swift
//  CometSports
//
//  Created by Qasr01 on 20/03/2024.
//

import Foundation

struct PhotoResponse: Decodable {
    let data: PhotoData
}

struct PhotoData: Decodable {
    let top: [Photo]
}

struct Photo: Decodable {
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
