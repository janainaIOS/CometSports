//
//  LoginViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 13/02/2024.
//

import Foundation

class LoginViewModel: NSObject {
    
    static let shared = LoginViewModel()
    
    func login(parameters: [String: Any], completion:@escaping (Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.login, parameter: parameters, decodeType: UserResponse.self) { model, responseDict, status, message in
            if status, let response = model?.response {
                UserDefaults.standard.user = response.data
                UserDefaults.standard.token = response.data?.token
            }
            completion(status, message)
        }
    }
    
    func register(parameters: [String: Any], completion:@escaping (Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.register, parameter: parameters, decodeType: UserResponse.self) { model, responseDict, status, message in
            completion(status, message)
        }
    }
}
