//
//  BreakingNews.swift
//  Comet Sports
//
//  Created by iosDev on 06/06/2023.
//

import Foundation

struct BreakingNewsList: Codable {
    var data: [BreakingData] = []
}

struct BreakingNews: Codable {
    var data: BreakingData
}

struct BreakingData: Codable {
    var attributes = Attributes()
    var type: String = ""
    var id: String = ""
    
    public init () {}
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        attributes = try (container.decodeIfPresent(Attributes.self, forKey: .attributes) ?? Attributes())
        type = try (container.decodeIfPresent(String.self, forKey: .type) ?? "")
        id = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
    }
}

struct Attributes: Codable {
    var titleTrans = TitleTranslates()
    var bodyTrans = TitleTranslates()
    var date: String = ""
    
    enum CodingKeys: String, CodingKey {
        case titleTrans = "title_trans"
        case bodyTrans = "body_trans"
        case date = "createdAt"
    }
    public init () {}
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        titleTrans = try (container.decodeIfPresent(TitleTranslates.self, forKey: .titleTrans) ?? TitleTranslates())
        bodyTrans = try (container.decodeIfPresent(TitleTranslates.self, forKey: .bodyTrans) ?? TitleTranslates())
        date = try (container.decodeIfPresent(String.self, forKey: .date) ?? "")
    }
}

struct TitleTranslates : Codable {
    var data = TitleData()
    public init () {}
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try (container.decodeIfPresent(TitleData.self, forKey: .data) ?? TitleData())
   
    }
}

struct TitleData: Codable {
    var en: String = ""
    var cn: String = ""
    
    enum CodingKeys: String, CodingKey {
        case en
        case cn = "zh_cn"
    }
    public init () {}
    
    init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        en = try (container.decodeIfPresent(String.self, forKey: .en) ?? "")
        cn = try (container.decodeIfPresent(String.self, forKey: .cn) ?? "")
    }
}
