//
//  HomeViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 26/05/2023.
//

import Foundation

enum MatchListType: String {
    case live = "live"
    case upcoming = "upcoming"
    case finished = "finished"
    case all = "all"
}

class HomeViewModel: NSObject {
    
    static let shared = HomeViewModel()
    var photoArray: [Photo] = []
    
    func getPhotos(completion:@escaping (Bool, String) -> Void) {
        
        NetworkManager.shared.initiateAPIRequest(with: photoURL, method: .get, encoding: .URLEncoding, decodeType: PhotoResponse.self) { model, responseDict, status, message in
            self.photoArray.removeAll()
            if status, let getModel = model {
                self.photoArray = getModel.data.top
                completion(true, "")
            } else {
                completion(false, message)
            }
        }
    }
    
    func getNewsList(pageNum: Int, dayoffset: Int, completion:@escaping ([News], Bool, String) -> Void) {
       // let url = URLs.news + "\(selectedLang == .en ? "en" : "cn")/\(pageNum)?dayoffsets=\(dayoffset)"
        let url = URLs.news + "\(selectedLang == .en ? "en" : "cn")/\(pageNum)"
        NetworkManager.shared.initiateAPIRequest(with: url, method: .get, encoding: .URLEncoding, decodeType: NewsResponse.self) { model, responseDict, status, message in
            
            if let data = model?.list {
                completion(data, true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func getnewsDetail(newsId: String = "", completion:@escaping (News, Bool, String) -> Void) {
        let url = URLs.newsDetail + "\(selectedLang == .en ? "en" : "cn")/\(newsId)"
        NetworkManager.shared.initiateAPIRequest(with: url, method: .get, encoding: .URLEncoding, decodeType: News.self) { model, responseDict, status, message in
            
            if let data = model {
                completion(data, true, "")
            } else {
                completion(News(), false, message)
            }
        }
    }
    
    func getMatches(date: Date, completion:@escaping ([Matches], Bool, String) -> Void) {
        print("date -- \(date)")
        let parameters: [String: Any] = [
            "lang": String(describing: selectedLang),
            "sport": "football",
            "date": date.formatDate(outputFormat: dateFormat.yyyyMMdd),
            "timezone": TimeZone.current.offsetInHours()
        ]
        print("date -- is  \(date.formatDate(outputFormat: dateFormat.yyyyMMdd))")
        
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.match, parameter: parameters, decodeType: LeagueResponse.self) { model, responseDict, status, message in
            
            if let data = model?.data {
                var matchArray: [Matches] = []
                for league in data {
                    var matches = league.matches
                    matches.mapProperty(\.league, league.league)
                    matches.mapProperty(\.leagueImage, league.logo)
                    matchArray.append(contentsOf: matches)
                }
                completion(matchArray, true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func getMatchDetail(slug: String = "", completion:@escaping (MatchDetail, Bool, String) -> Void){
        
        let parameters: [String: Any] = [
            "lang": String(describing: selectedLang),
            "sport": "football",
            "slug": slug,
            "timezone": TimeZone.current.offsetInHours()
        ]
        NetworkManager.shared.initiateAPIRequest(with: URLs.match, parameter: parameters, decodeType: MatchDetailResponse.self) { model, responseDict, status, message in
            
            if let data = model?.data {
                completion(data, true, "")
            } else {
                completion(MatchDetail(), false, message)
            }
        }
    }
    
    func getHotMatches(completion:@escaping ([MatchList], Bool, String) -> Void) {
        
        let parameters: [String: Any] = ["hotMatches":true]
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.footballMatches, method: .get, parameter: parameters, encoding: .URLEncoding, decodeType: MatchListResponse.self) { model, responseDict, status, message in
            
            if let data = model {
                if ((data.hotMatches?.isEmpty) != nil) {
                    self.getLiveMatches { matches, status, messg in
                        completion(matches, status, "")
                    }
                } else {
                    completion(data.hotMatches ?? [], true, "")
                }
            } else {
                completion([], false, message)
            }
        }
    }
    
    func getLiveMatches(completion:@escaping ([MatchList], Bool, String) -> Void) {
        
        let parameters: [String: Any] = ["matchStatus":"live"]
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.footballMatches, method: .get, parameter: parameters, encoding: .URLEncoding, decodeType: MatchListResponse.self) { model, responseDict, status, message in
            
            if let data = model {
                completion(data.matchList ?? [], true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func getFootballMatches(days: Int, completion:@escaping ([MatchList], Bool, String) -> Void) {
        let url = days == 0 ? URLs.footballMatches : URLs.footballPastMatch + "\(days)"
        
        NetworkManager.shared.initiateAPIRequest(with: url, method: .get, encoding: .URLEncoding, decodeType: MatchListResponse.self) { model, responseDict, status, message in
            
            if let data = model {
                completion(data.matchList ?? [], true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func getFootballH2HMatches(matchId: String, completion:@escaping (H2HMatchListModel, Bool, String) -> Void) {
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.footballH2HMatchList + "\(matchId)", method: .get, parameter: [:], encoding: .URLEncoding, decodeType: H2HMatchListModel.self) { model, responseDict, status, message in
            
            if let data = model {
                completion(model ?? H2HMatchListModel(), true, "")
            } else {
                completion(H2HMatchListModel(), false, message)
            }
        }
    }
    
    func getPredictions(completion:@escaping ([Prediction], Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.prediction, method: .get, encoding: .URLEncoding, decodeType: PredictionResponse.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                completion(data.data ?? [], true, "")
            } else {
                completion([], false, message)
            }
        }
    }
}
