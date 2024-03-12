//
//  MatchList.swift
//  Comet Sports
//
//  Created by iosDev on 15/02/2024.
//

import Foundation

struct MatchListResponse: Codable {
    var hotMatches: [MatchList]? = []
    var matchList: [MatchList]? = []
}

// MARK: - MatchList
struct MatchList: Codable {
    var id: String = ""
    var statusID: Int = 0
    var leagueID: String = ""
    var seasonID: String = ""
    var homeTeamID: String = ""
    var awayTeamID: String = ""
    var matchDate: String = ""
    var refereeID: String = ""
    var homePosition: String = "--"
    var awayPosition: String = "--"
    var matchPosition: MatchPosition?
    var coverage = Coverage()
    var round = Round()
    var homeInfo = TeamInfo()
    var awayInfo = TeamInfo()
    var leagueInfo = LeagueInfo()
    var odds = Odds()
    var environment = Environment()
    
    enum CodingKeys: String, CodingKey {
        case id
        case statusID = "status_id"
        case leagueID = "competition_id"
        case seasonID = "season_id"
        case homeTeamID = "home_team_id"
        case awayTeamID = "away_team_id"
        case matchDate = "match_timing"
        case refereeID = "referee_id"
        case homePosition = "home_position"
        case awayPosition = "away_position"
        case matchPosition = "position"
        case coverage, round
        case homeInfo = "home_Info"
        case awayInfo = "away_Info"
        case leagueInfo = "league_Info"
        case odds, environment
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
        statusID = try (container.decodeIfPresent(Int.self, forKey: .statusID) ?? 0)
        leagueID = try (container.decodeIfPresent(String.self, forKey: .leagueID) ?? "")
        seasonID = try (container.decodeIfPresent(String.self, forKey: .seasonID) ?? "")
        homeTeamID = try (container.decodeIfPresent(String.self, forKey: .homeTeamID) ?? "")
        awayTeamID = try (container.decodeIfPresent(String.self, forKey: .awayTeamID) ?? "")
        matchDate = try (container.decodeIfPresent(String.self, forKey: .matchDate) ?? "")
        refereeID = try (container.decodeIfPresent(String.self, forKey: .refereeID) ?? "")
        homePosition = try (container.decodeIfPresent(String.self, forKey: .homePosition) ?? "--")
        awayPosition = try (container.decodeIfPresent(String.self, forKey: .awayPosition) ?? "--")
        matchPosition = try (container.decodeIfPresent(MatchPosition.self, forKey: .matchPosition) ?? MatchPosition())
        coverage = try (container.decodeIfPresent(Coverage.self, forKey: .coverage) ?? Coverage())
        round = try (container.decodeIfPresent(Round.self, forKey: .round) ?? Round())
        homeInfo = try (container.decodeIfPresent(TeamInfo.self, forKey: .homeInfo) ?? TeamInfo())
        awayInfo = try (container.decodeIfPresent(TeamInfo.self, forKey: .awayInfo) ?? TeamInfo())
        leagueInfo = try (container.decodeIfPresent(LeagueInfo.self, forKey: .leagueInfo) ?? LeagueInfo())
        odds = try (container.decodeIfPresent(Odds.self, forKey: .odds) ?? Odds())
        environment = try (container.decodeIfPresent(Environment.self, forKey: .environment) ?? Environment())
    }
}

// MARK: - TeamInfo
struct TeamInfo: Codable {
    var enName: String = ""
    var cnName: String = ""
    var enShortName: String = ""
    var logo: String = ""
    var homeScore: Int = 0
    var awayScore: Int = 0
    var halfTimeScore: Int = 0
    var redCards: Int = 0
    var yellowCards: Int = 0
    var cornerScore: Int = 0
    var overtimeScore: Int = 0
    var penaltyScore: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case enName = "en_name"
        case cnName = "cn_name"
        case enShortName = "en_short_name"
        case logo
        case homeScore = "home_score"
        case awayScore = "away_score"
        case halfTimeScore = "half_time_score"
        case yellowCards = "yellow_cards"
        case redCards = "red_cards"
        case cornerScore = "corner_score"
        case overtimeScore = "overtime_score"
        case penaltyScore = "penalty_score"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        enName = try container.decodeIfPresent(String.self, forKey: .enName) ?? ""
        cnName = try container.decodeIfPresent(String.self, forKey: .cnName) ?? ""
        enShortName = try container.decodeIfPresent(String.self, forKey: .enShortName) ?? ""
        logo = try container.decodeIfPresent(String.self, forKey: .logo) ?? ""
        homeScore = try container.decodeIfPresent(Int.self, forKey: .homeScore) ?? 0
        awayScore = try container.decodeIfPresent(Int.self, forKey: .awayScore) ?? 0
        halfTimeScore = try container.decodeIfPresent(Int.self, forKey: .halfTimeScore) ?? 0
        redCards = try container.decodeIfPresent(Int.self, forKey: .redCards) ?? 0
        yellowCards = try container.decodeIfPresent(Int.self, forKey: .yellowCards) ?? 0
        cornerScore = try container.decodeIfPresent(Int.self, forKey: .cornerScore) ?? 0
        overtimeScore = try container.decodeIfPresent(Int.self, forKey: .overtimeScore) ?? 0
        penaltyScore = try container.decodeIfPresent(Int.self, forKey: .penaltyScore) ?? 0
    }
}

struct MatchPosition: Codable {
    var home: String? = ""
    var away: String? = ""
}

// MARK: - Coverage
struct Coverage: Codable {
    var mlive: Int = 0
    var lineup: Int = 0
}

// MARK: - Environment
struct Environment: Codable {
    var weather: Int = 0
    var pressure: String = ""
    var temperature: String = ""
    var wind: String = ""
    var humidity: String = ""
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weather = try container.decodeIfPresent(Int.self, forKey: .weather) ?? 0
        pressure = try container.decodeIfPresent(String.self, forKey: .pressure) ?? ""
        temperature = try container.decodeIfPresent(String.self, forKey: .temperature) ?? ""
        wind = try container.decodeIfPresent(String.self, forKey: .wind) ?? ""
        humidity = try container.decodeIfPresent(String.self, forKey: .humidity) ?? ""
    }
}

// MARK: - LeagueInfo
struct LeagueInfo: Codable {
    var enName: String = ""
    var cnName: String = ""
    var shortName: String = ""
    var primaryColor: String = ""
    var logo: String = ""
    
    enum CodingKeys: String, CodingKey {
        case enName = "en_name"
        case cnName = "cn_name"
        case shortName = "short_name"
        case primaryColor = "primary_color"
        case logo
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enName = try container.decodeIfPresent(String.self, forKey: .enName) ?? ""
        cnName = try container.decodeIfPresent(String.self, forKey: .cnName) ?? ""
        shortName = try container.decodeIfPresent(String.self, forKey: .shortName) ?? ""
        primaryColor = try container.decodeIfPresent(String.self, forKey: .primaryColor) ?? ""
        logo = try container.decodeIfPresent(String.self, forKey: .logo) ?? ""
    }
}

// MARK: - Odds
struct Odds: Codable {
    var oddsInit = OddsInit()
    
    enum CodingKeys: String, CodingKey {
        case oddsInit = "init"
    }
    
    init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        oddsInit = try container.decodeIfPresent(OddsInit.self, forKey: .oddsInit) ?? OddsInit()
    }
}

// MARK: - Init
struct OddsInit: Codable {
    var asia = OddsInfo()
    var euro = OddsInfo()
    var bigSmall = OddsInfo()
    
    init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        asia = try container.decodeIfPresent(OddsInfo.self, forKey: .asia) ?? OddsInfo()
        euro = try container.decodeIfPresent(OddsInfo.self, forKey: .euro) ?? OddsInfo()
        bigSmall = try container.decodeIfPresent(OddsInfo.self, forKey: .bigSmall) ?? OddsInfo()
    }
}

// MARK: - Asia
struct OddsInfo: Codable {
    var home: Double = 0
    var handicap: Double = 0
    var away: Double = 0
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        home = try container.decodeIfPresent(Double.self, forKey: .home) ?? 0
        handicap = try container.decodeIfPresent(Double.self, forKey: .handicap) ?? 0
        away = try container.decodeIfPresent(Double.self, forKey: .away) ?? 0
    }
}

// MARK: - Round
struct Round: Codable {
    var stageID: String = ""
    var roundNum: Int = 0
    var groupNum: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case stageID = "stage_id"
        case roundNum = "round_num"
        case groupNum = "group_num"
    }
    
    init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stageID = try (container.decodeIfPresent(String.self, forKey: .stageID) ?? "")
        roundNum = try (container.decodeIfPresent(Int.self, forKey: .roundNum) ?? 0)
        groupNum = try (container.decodeIfPresent(Int.self, forKey: .groupNum) ?? 0)
    }
}

struct H2HMatchListModel: Codable {
    var history: History?
}

struct History: Codable {
    var homeMatchInfo: [MatchInfo]?
    var awayMatchInfo: [MatchInfo]?
   
    enum CodingKeys: String, CodingKey {
        case homeMatchInfo = "home_match_info"
        case awayMatchInfo = "away_match_info"
    }
}

struct MatchInfo: Codable {
    var homeName: String?
    var awayName: String?
    var homeScore: Int?
    var awayScore: Int?
    var homeHalfScore: Int?
    var awayHalfScore: Int?
    var homeOvertimeScore: Int?
    var awayOvertimeScore: Int?
    var homeRanking: String?
    var awayRanking: String?
    
    enum CodingKeys: String, CodingKey {
        case homeName = "home_en_name"
        case awayName = "away_en_name"
        case homeScore = "home_team_score"
        case awayScore = "away_team_score"
        case homeHalfScore = "home_team_half_time_score"
        case awayHalfScore = "away_team_half_time_score"
        case homeOvertimeScore = "home_team_overTime_score"
        case awayOvertimeScore = "away_team_overTime_score"
        case homeRanking = "home_league_ranking"
        case awayRanking = "away_league_ranking"
    }
}
