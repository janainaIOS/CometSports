//
//  Prediction.swift
//  Comet Sports
//
//  Created by iosDev on 21/02/2024.
//

import Foundation

struct PredictionResponse: Codable {
    var response: PredictionData?
    var error: PredictionData?
}

struct PredictionData: Codable {
    var code: Int?
    var messages: [String]?
    var data: [Prediction]?
}

// MARK: - Prediction
struct Prediction: Codable {
    let id, userID: Int?
    let createdAt, updatedAt, comments: String?
    let sportType, title: String?
    let type, predictedTeam, predictedType: String?
    let match: PredMatch?
    let predictionStreak: String?
    let user: PredUser?
    let reddragonUser: ReddragonUser?
    let isSuccess: Int?
    let goals: CGFloat?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comments
        case sportType, title, type
        case match
        case predictionStreak = "prediction_streak"
        case isSuccess = "is_success"
        case predictedTeam = "predicted_team"
        case predictedType = "predicted_type"
        case goals
        case user
        case reddragonUser = "reddragon_user"
    }
}

// MARK: - Match
struct PredMatch: Codable {
    let id, seasonID, competitionID, homeTeamID: String?
    let awayTeamID: String?
    let statusID: Int?
    let matchTime: String?
    let homeScores, awayScores: Scores?
    let homePosition, awayPosition: String?
    let relatedID: String?
    let aggScore: [Int]?
    let updatedAt, status: String?
    let matchTimestamp: Int?
    let competetionDetails, awayTeamDetail, homeTeamDetail: PredTeamDetail?

    enum CodingKeys: String, CodingKey {
        case id
        case seasonID = "season_id"
        case competitionID = "competition_id"
        case homeTeamID = "home_team_id"
        case awayTeamID = "away_team_id"
        case statusID = "status_id"
        case matchTime = "match_time"
        case homeScores = "home_scores"
        case awayScores = "away_scores"
        case homePosition = "home_position"
        case awayPosition = "away_position"
        case relatedID = "related_id"
        case aggScore = "agg_score"
        case updatedAt = "updated_at"
        case status
        case matchTimestamp = "match_timestamp"
        case competetionDetails = "competetion_details"
        case awayTeamDetail = "away_team_detail"
        case homeTeamDetail = "home_team_detail"
    }
}

// MARK: - Scores
struct Scores: Codable {
    let score, halftimeScore, redCards, yellowCards: Int?
    let corners, overtime, penalty: Int?

    enum CodingKeys: String, CodingKey {
        case score = "Score"
        case halftimeScore = "Halftime_score"
        case redCards = "Red_cards"
        case yellowCards = "Yellow_cards"
        case corners = "Corners"
        case overtime = "Overtime"
        case penalty = "Penalty"
    }
}

// MARK: - TeamDetail
struct PredTeamDetail: Codable {
    let id, name, shortName: String?
    let logo: String?
    let nameZhn: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
        case logo
        case nameZhn = "name_zhn"
    }
}

// MARK: - ReddragonUser
struct ReddragonUser: Codable {
    var id: Int?
    var name, email, createdAt,phoneNumber: String?
    var otpVerified: Int?
    var otpVerifiedAt: String?
    var gender, about: String?
    var locationID: Int?
    var locationName: String?
    var profileImg: String?
    var prefferedLanguage: String?
    var block: Int?
    var signupVia: String?
    var wallet: Int?
    var username, fullName: String?
    var streetPlayerUpdated: Int?
    var dob, countryCode: String?
    var predictionSuccessRate: Double?
    var betSuccessRate: Int?
    var rating:String?
    var messagesCount, postCount, revealedPredictionCount: Int?
    var following: Bool?
    var totalFollowerCount: Int?
    var tags: [String]?
    var historicTags: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case phoneNumber = "phone_number"
        case otpVerified = "otp_verified"
        case otpVerifiedAt = "otp_verified_at"
        case gender, about
        case locationID = "location_id"
        case locationName = "location_name"
        case profileImg = "profile_img"
        case prefferedLanguage = "preffered_language"
        case block
        case signupVia = "signup_via"
        case wallet, username
        case fullName = "full_name"
        case streetPlayerUpdated = "street_player_updated"
        case dob
        case rating
        case countryCode = "country_code"
        case predictionSuccessRate = "prediction_success_rate"
        case betSuccessRate = "bet_success_rate"
        case revealedPredictionCount = "revealed_prediction_count"
        case following, totalFollowerCount, tags, historicTags
    }
}

// MARK: - User
struct PredUser: Codable {
    let id: Int?
    let name, email: String?
    let createdAt, updatedAt, signupVia: String?
    let imgURL: String?
    let predStats: PredStats?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case signupVia = "signup_via"
        case imgURL = "img_url"
        case predStats = "pred_stats"
    }
}

// MARK: - PredStats
struct PredStats: Codable {
    let allCnt, successCnt, unsuccessCnt, coins: Int?
    let successRate: Double?

    enum CodingKeys: String, CodingKey {
        case allCnt, successCnt, unsuccessCnt, coins
        case successRate = "success_rate"
    }
}
