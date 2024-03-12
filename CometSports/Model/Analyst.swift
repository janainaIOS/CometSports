//
//  Analyst.swift
//  Comet Sports
//
//  Created by iosDev on 29/05/2023.
//

import Foundation

struct AnalystListResponse: Codable {
    var data: [Analyst]? = []
    var message: String?
}

struct Analyst: Codable {
    
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var winRate: String = ""
    var wonFootballAnalysis: String = ""
    var totalFootballAnalysis: String = ""
    var totalFollower: String = ""
    var totalAnalysis: String = ""
    var totalPost: String = ""
    
    public init () {}
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "username"
        case image = "user_image_url"
        case winRate = "football_accuracy"
        case wonFootballAnalysis = "total_football_analysis_won"
        case totalFootballAnalysis = "total_football_analysis_created"
        case totalFollower = "total_follower"
        case totalAnalysis = "total_analysis"
        case totalPost = "total_post"
    }
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
        name = try (container.decodeIfPresent(String.self, forKey: .name) ?? "")
        image = try (container.decodeIfPresent(String.self, forKey: .image) ?? "")
        winRate = try (container.decodeIfPresent(String.self, forKey: .winRate) ?? "")
        wonFootballAnalysis = try (container.decodeIfPresent(String.self, forKey: .wonFootballAnalysis) ?? "")
        totalFootballAnalysis = try (container.decodeIfPresent(String.self, forKey: .totalFootballAnalysis) ?? "")
        totalFollower = try (container.decodeIfPresent(String.self, forKey: .totalFollower) ?? "")
        totalAnalysis = try (container.decodeIfPresent(String.self, forKey: .totalAnalysis) ?? "")
        totalPost = try (container.decodeIfPresent(String.self, forKey: .totalPost) ?? "")
    }
}

struct AnalystDetailResponse: Codable {
    var data: AnalystDetail?
    var message: String?
}

struct AnalysisResponse: Codable {
    var data: [AnalystMatch]? = []
    var message: String?
}

struct AnalystDetail: Codable {
    
    var matchList: [AnalystMatch] = []
    var user = Analyst()
    
    enum CodingKeys: String, CodingKey {
        case user
        case matchList = "prediction"
    }
    
    public init () {}
}

struct AnalystMatch: Codable {
   
    var matchId: String = ""
    var homeTeam: String = ""
    var awayTeam: String = ""
    var homeLogo: String = ""
    var awayLogo: String = ""
    var homeScore: String = ""
    var awayScore: String = ""
    var league: String = ""
    var finalResult: String = "0"
    var color: String = ""
    var date: String = ""
    var relativeTime: String = ""
    var explanation: String = ""
    
    enum CodingKeys: String, CodingKey {
        case color, explanation
        case matchId = "match_id"
        case homeTeam = "home_team_name"
        case awayTeam = "away_team_name"
        case homeLogo = "home_team_logo"
        case awayLogo = "away_team_logo"
        case homeScore = "home_team_score"
        case awayScore = "away_team_score"
        case league = "league_name"
        case finalResult = "final_result"
        case date = "match_time"
        case relativeTime = "relative_time"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        matchId = try (container.decodeIfPresent(String.self, forKey: .matchId) ?? "")
        homeTeam = try (container.decodeIfPresent(String.self, forKey: .homeTeam) ?? "")
        awayTeam = try (container.decodeIfPresent(String.self, forKey: .awayTeam) ?? "")
        homeLogo = try (container.decodeIfPresent(String.self, forKey: .homeLogo) ?? "")
        awayLogo = try (container.decodeIfPresent(String.self, forKey: .awayLogo) ?? "")
        homeScore = try (container.decodeIfPresent(String.self, forKey: .homeScore) ?? "")
        awayScore = try (container.decodeIfPresent(String.self, forKey: .awayScore) ?? "")
        league = try (container.decodeIfPresent(String.self, forKey: .league) ?? "")
        finalResult = try (container.decodeIfPresent(String.self, forKey: .finalResult) ?? "0")
        color = try (container.decodeIfPresent(String.self, forKey: .color) ?? "")
        date = try (container.decodeIfPresent(String.self, forKey: .date) ?? "")
        explanation = try (container.decodeIfPresent(String.self, forKey: .explanation) ?? "")
        relativeTime = try (container.decodeIfPresent(String.self, forKey: .relativeTime) ?? "")
    }
}

