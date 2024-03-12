//
//  AnalystViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 26/05/2023.
//

import Foundation

class AnalystViewModel: NSObject {
    
    static let shared = AnalystViewModel()
    var analystArray: [Analyst] = []
    
    func getAnalystList(pageNum: Int, completion:@escaping (Bool, String) -> Void) {
        
        let parameters: [String: Any] = [
            "lang": String(describing: selectedLang),
            "sport_type": 0, // 0 - football
            "offset": pageNum,
            "session": ""
        ]
        NetworkManager.shared.initiateAPIRequest(with: URLs.analystList, parameter: parameters, encoding: .URLEncoding, decodeType: AnalystListResponse.self) { model, responseDict, status, message in
            let errorMessage = model?.message ?? message
            self.analystArray.removeAll()
            if let data = model?.data {
                self.analystArray = data.shuffled() //reversed()
                completion(true, "")
            } else {
                completion(false, errorMessage)
            }
        }
    }
    
    func getAnalystDetail(id: String, completion:@escaping (AnalystDetail, Bool, String) -> Void) {
        
        let parameters: [String: Any] = [
            "lang": String(describing: selectedLang),
            "sport_type": 0, // 0 - football
            "offset": 3,
            "session": "",
            "id": id
        ]
        NetworkManager.shared.initiateAPIRequest(with: URLs.analystDetail, parameter: parameters, encoding: .URLEncoding, decodeType: AnalystDetailResponse.self) { model, responseDict, status, message in
            let errorMessage = model?.message ?? message
            if let data = model?.data {
                completion(data, true, "")
            } else {
                completion(AnalystDetail(), false, errorMessage)
            }
        }
    }
    
    func getAnalysis(userId: String, matchId: String, completion:@escaping (AnalystMatch, Bool, String) -> Void) {
        
        let parameters: [String: Any] = [
            "lang": String(describing: selectedLang),
            "sport_type": 0, // 0 - football
            "offset": 0,
            "session": "",
            "match_id": matchId,
            "user_id": userId
        ]
        NetworkManager.shared.initiateAPIRequest(with: URLs.analysis, parameter: parameters, encoding: .URLEncoding, decodeType: AnalysisResponse.self) { model, responseDict, status, message in
            let errorMessage = model?.message ?? message
            if let data = model?.data {
                completion(data.first ?? AnalystMatch(), true, "")
            } else {
                completion(AnalystMatch(), false, errorMessage)
            }
        }
    }
}
