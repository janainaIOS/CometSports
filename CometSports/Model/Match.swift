//
//  Match.swift
//  Comet Sports
//
//  Created by iosDev on 08/07/2023.
//

import Foundation

struct LeagueResponse: Codable {
    var data: [League] = []
}

struct MatchDetailResponse: Codable {
    var data: MatchDetail
}

struct MatchDetail: Codable {
    
    var league: String = ""
    var leagueImage: String = ""
    var leagueSlug: String = ""
    var sectionName: String = ""
    var about: String = ""
    var matchState: String = ""
    var homeTeam: String = ""
    var awayTeam: String = ""
    var homeScore: String = ""
    var awayScore: String = ""
    var homeImage: String = ""
    var awayImage: String = ""
    var standings: [Standings] = []
    var homeEvents: [Event] = []
    var awayEvents: [Event] = []
    var medias: [Medias] = []
    var statistics: [Statistics] = []
    var homeLineup = Lineup()
    var awayLineup = Lineup()
    var progress: [ProgressList] = []
    
    enum CodingKeys: String, CodingKey {
        case about, standings, medias, statistics, progress
        case league = "league_name"
        case leagueSlug = "league_slug"
        case sectionName = "section_name"
        case matchState = "match_state"
        case homeTeam = "home_team_name"
        case awayTeam = "away_team_name"
        case homeScore = "home_score"
        case awayScore = "away_score"
        case homeImage = "home_team_image"
        case awayImage = "away_team_image"
        case homeEvents = "home_events"
        case awayEvents = "away_events"
        case homeLineup = "home_lineup"
        case awayLineup = "away_lineup"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        league = try (container.decodeIfPresent(String.self, forKey: .league) ?? "")
        leagueSlug = try (container.decodeIfPresent(String.self, forKey: .leagueSlug) ?? "")
        sectionName = try (container.decodeIfPresent(String.self, forKey: .sectionName) ?? "")
        about = try (container.decodeIfPresent(String.self, forKey: .about) ?? "")
        matchState = try (container.decodeIfPresent(String.self, forKey: .matchState) ?? "")
        homeTeam = try (container.decodeIfPresent(String.self, forKey: .homeTeam) ?? "")
        awayTeam = try (container.decodeIfPresent(String.self, forKey: .awayTeam) ?? "")
        homeScore = try (container.decodeIfPresent(String.self, forKey: .homeScore) ?? "")
        awayScore = try (container.decodeIfPresent(String.self, forKey: .awayScore) ?? "")
        homeImage = try (container.decodeIfPresent(String.self, forKey: .homeImage) ?? "")
        awayImage = try (container.decodeIfPresent(String.self, forKey: .awayImage) ?? "")
        standings = try (container.decodeIfPresent([Standings].self, forKey: .standings) ?? [])
        homeEvents = try (container.decodeIfPresent([Event].self, forKey: .homeEvents) ?? [])
        awayEvents = try (container.decodeIfPresent([Event].self, forKey: .awayEvents) ?? [])
        medias = try (container.decodeIfPresent([Medias].self, forKey: .medias) ?? [])
        statistics = try (container.decodeIfPresent([Statistics].self, forKey: .statistics) ?? [])
        homeLineup = try (container.decodeIfPresent(Lineup.self, forKey: .homeLineup) ?? Lineup())
        awayLineup = try (container.decodeIfPresent(Lineup.self, forKey: .awayLineup) ?? Lineup())
        progress = try (container.decodeIfPresent([ProgressList].self, forKey: .progress) ?? [])
    }
}

struct League: Codable {
    
    var league: String = ""
    var slug: String = ""
    var logo: String = ""
    var matches: [Matches] = []
    
    enum CodingKeys: String, CodingKey {
        case league, matches, logo
        case slug = "league_slug"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        league = try (container.decodeIfPresent(String.self, forKey: .league) ?? "")
        slug = try (container.decodeIfPresent(String.self, forKey: .slug) ?? "")
        logo = try (container.decodeIfPresent(String.self, forKey: .logo) ?? "")
        matches = try (container.decodeIfPresent([Matches].self, forKey: .matches) ?? [])
    }
}

struct Matches: Codable {
    
    var homeName: String = ""
    var awayName: String = ""
    var homeScore: String = ""
    var awayScore: String = ""
    var matchState: String = ""
    var slug: String = ""
    var league: String = ""
    var leagueImage: String = ""
    
    enum CodingKeys: String, CodingKey {
        case slug
        case homeName = "home_team"
        case awayName = "away_team"
        case homeScore = "home_score"
        case awayScore = "away_score"
        case matchState = "match_state"
    }
}

struct Standings: Codable {
    
    var name: String = ""
    var tableHeader: [String] = []
    var tableData: [[String]] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case tableHeader = "table_header"
        case tableData = "table_data"
    }
    
    public init () {}
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try (container.decodeIfPresent(String.self, forKey: .name) ?? "")
        tableHeader = try (container.decodeIfPresent([String].self, forKey: .tableHeader) ?? [])
        tableData = try (container.decodeIfPresent([[String]].self, forKey: .tableData) ?? [])
    }
}

struct Medias: Codable {
    
    var date: String = ""
    var preview: String = ""
    var subtitle: String = ""
    var title: String = ""
    var video: String = ""
}

struct Lineup: Codable {
    
    var lineupState: String = ""
    var info: [KeyValue] = []
    var indicators: [KeyValue] = []
    var playerHeader: [[String]] = []
    var playerMain: [[String]] = []
    var playerSubstitute: [[String]] = []
    
    enum CodingKeys: String, CodingKey {
        case info, indicators
        case lineupState = "lineup_state_1"
        case playerHeader = "player_header"
        case playerMain = "player_main"
        case playerSubstitute = "player_substitute"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lineupState = try (container.decodeIfPresent(String.self, forKey: .lineupState) ?? "")
        info = try (container.decodeIfPresent([KeyValue].self, forKey: .info) ?? [])
        indicators = try (container.decodeIfPresent([KeyValue].self, forKey: .indicators) ?? [])
        playerHeader = try (container.decodeIfPresent([[String]].self, forKey: .playerHeader) ?? [])
        playerMain = try (container.decodeIfPresent([[String]].self, forKey: .playerMain) ?? [])
        playerSubstitute = try (container.decodeIfPresent([[String]].self, forKey: .playerSubstitute) ?? [])
    }
}

struct Statistics: Codable {
    
    var data: [KeyValue] = []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try (container.decodeIfPresent([KeyValue].self, forKey: .data) ?? [])
    }
}

struct KeyValue: Codable {
    
    var key: String = ""
    var value: String = ""
    var homeValue: String = ""
    var awayValue: String = ""
    var homePercent: Float = 0
    
    enum CodingKeys: String, CodingKey {
        case key, value
        case homeValue = "home_value"
        case awayValue = "away_value"
        case homePercent = "home_percent"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try (container.decodeIfPresent(String.self, forKey: .key) ?? "")
        value = try (container.decodeIfPresent(String.self, forKey: .value) ?? "")
        homeValue = try (container.decodeIfPresent(String.self, forKey: .homeValue) ?? "")
        awayValue = try (container.decodeIfPresent(String.self, forKey: .awayValue) ?? "")
        homePercent = try (container.decodeIfPresent(Float.self, forKey: .homePercent) ?? 0)
    }
}

struct Event: Codable {
    
    var league: String = ""
    var slug: String = ""
    var logo: String = ""
    var matches: [EventMatch] = []
    
    enum CodingKeys: String, CodingKey {
        case matches
        case league = "league_name"
        case logo = "league_logo"
        case slug = "league_slug"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        league = try (container.decodeIfPresent(String.self, forKey: .league) ?? "")
        slug = try (container.decodeIfPresent(String.self, forKey: .slug) ?? "")
        logo = try (container.decodeIfPresent(String.self, forKey: .logo) ?? "")
        matches = try (container.decodeIfPresent([EventMatch].self, forKey: .matches) ?? [])
    }
}

struct EventMatch: Codable {
    
    var homeName: String = ""
    var awayName: String = ""
    var homeScore: String = ""
    var awayScore: String = ""
    var date: String = ""
    var slug: String = ""
    
    enum CodingKeys: String, CodingKey {
        case slug, date
        case homeName = "home_name"
        case awayName = "away_name"
        case homeScore = "home_score"
        case awayScore = "away_score"
    }
}

struct ProgressList: Codable {
     var data: [ProgressData] = []
}

struct ProgressData: Codable {
    
    var mainPlayer: String = ""
    var subPlayer: String = ""
    var mainPlayerImage: String = ""
    var subPlayerImage: String = ""
    var action: String = ""
    var time: String = ""
    
    enum CodingKeys: String, CodingKey {
        case action, time
        case mainPlayer = "main_player_name"
        case subPlayer = "sub_player_name"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mainPlayer = try (container.decodeIfPresent(String.self, forKey: .mainPlayer) ?? "")
        subPlayer = try (container.decodeIfPresent(String.self, forKey: .subPlayer) ?? "")
        subPlayer = subPlayer.replacingOccurrences(of: "instead ", with: "")
        action = try (container.decodeIfPresent(String.self, forKey: .action) ?? "")
        time = try (container.decodeIfPresent(String.self, forKey: .time) ?? "")
    }
}

