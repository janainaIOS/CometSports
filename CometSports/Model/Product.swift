//
//  Product.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import Foundation

struct ProductListResponse: Codable {
    var data: [Product]? = []
}

struct ProductResponse: Codable {
    var data: Product?
}

struct Product: Codable {

    var id: Int = 0
    var title: String = ""
    var descriptn: String = ""
    var content: String   = ""
    var price: String = "0"
    var coverPath: String = ""
    var date: String = ""
    var tagList: [Tag] = []
    var photos: [ProductPhoto] = []
    var paramtList: [ProductParam] = []
    var keywords: String = ""

    enum CodingKeys: String, CodingKey {
        case id, title, content, price, keywords
        case descriptn = "description"
        case coverPath = "cover_path"
        case date = "updated_at"
        case tagList = "tag"
        case photos = "product_photo"
        case paramtList = "product_param"
    }
    public init () {}
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        descriptn = try (container.decodeIfPresent(String.self, forKey: .descriptn) ?? "")
        content = try (container.decodeIfPresent(String.self, forKey: .content) ?? "")
        price = try (container.decodeIfPresent(String.self, forKey: .price) ?? "")
        coverPath = try (container.decodeIfPresent(String.self, forKey: .coverPath) ?? "")
        date = try (container.decodeIfPresent(String.self, forKey: .date) ?? "")
        tagList = try (container.decodeIfPresent([Tag].self, forKey: .tagList) ?? [])
        photos = try (container.decodeIfPresent([ProductPhoto].self, forKey: .photos) ?? [])
        paramtList = try (container.decodeIfPresent([ProductParam].self, forKey: .paramtList) ?? [])
        keywords = try (container.decodeIfPresent(String.self, forKey: .keywords) ?? "")
    }
}

struct Tag: Codable {

    var id: Int = 0
    var title: String = ""
}

struct ProductPhoto: Codable {

    var id: Int = 0
    var coverPath: String = ""

    enum CodingKeys: String, CodingKey {
        case coverPath = "cover_path"
    }
}

struct ProductParam: Codable {

    var value: String = ""
    var title: String = ""

    enum CodingKeys: String, CodingKey {
        case value = "title"
        case title = "description"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try (container.decodeIfPresent(String.self, forKey: .value) ?? "")
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        title = (title.components(separatedBy: "：")).first ?? title
        /*
         "title": "500.00g",
         "description": "商品毛重：500.00g"
         */
    }
}
