//
//  SettingsViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 14/02/2024.
//

import Foundation

class SettingsViewModel: NSObject {
    
    static let shared = SettingsViewModel()
    
    func updateUser(parameters: [String: Any], completion:@escaping (Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.updateUser, method: .put, parameter: parameters, decodeType: ProfileResponse.self) { model, responseDict, status, message in
            
            if status, let response = model?.response {
                UserDefaults.standard.user = response.data
            }
            completion(status, message)
        }
    }
    
    func deleteAccount(onCompletion:@escaping (Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.updateUser, method: .delete, decodeType: BasicResponse2.self) { model, responseDict, status, message in
            onCompletion(status, message)
        }
    }
    
    func uploadImage(imageData: Data, imageName: String, completion:@escaping (PostImage?, Bool, String) -> Void) {
        let parameter: [String: Any] = ["type": "temp"]
        NetworkManager.shared.initiateMultipartFormDataAPIRequest(with: URLs.postImage, parameter: parameter, imageData: imageData, imageName: imageName, decodeType: ImageResponse.self) { model, responseDict, status, message in
            if let data = model?.response {
                completion(data.data, true, "")
            } else {
                completion(nil, false, message)
            }
        }
    }
}
