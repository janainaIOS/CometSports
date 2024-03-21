//
//  NetworkManager.swift
//  Comet Sports
//
//  Created by iosDev on 29/05/2023.
//

import Foundation
import Alamofire

enum Encoding {
    case URLEncoding
    case JSONEncoding
}

typealias Completion = (Data?, [String: Any]?, Bool, String) -> Void

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func initiateAPIRequest<T: Decodable>(with url: String, method: HTTPMethod = .post, parameter: [String: Any] = [:], encoding: Encoding = .JSONEncoding, decodeType: T.Type, completion: @escaping(T?, [String: Any]?, Bool, String) -> Void) {
        let parameterEncoding: ParameterEncoding = encoding == .URLEncoding ? URLEncoding.default : JSONEncoding.default
        
   // print("[Request] [\(method.rawValue)]:==> \(url)     [Parameters] :==> \(parameter)")
        
        if Connectivity.isConnectedToInternet() {
            AF.request(url, method: method, parameters: parameter, encoding: parameterEncoding, headers: getHeader())
                .validate(contentType: ["application/json"])
                .responseDecodable(of: decodeType) { (response) in
                    
                    switch response.result {
                    case .success:
                        
                        guard let responseData = response.data else {
                            completion(nil, nil, false,  ErrorMessage.somethingWentWrong)
                            return
                        }
                        
                        let _response = try? JSONSerialization.jsonObject(with: responseData, options: [])
                        var responseDictionary = _response as? [String: Any]
                        
                        if responseDictionary == nil {
                            if _response is [[String: Any]] {
                                responseDictionary = ["data" : _response ?? []]
                            } else if _response is String {
                                responseDictionary = ["data" : _response ?? ""]
                            }
                        }
                        
                 //  print("[Response] :==> \(url)\n\(responseDictionary ?? [:])")
                        
                        //Find error or success
                        var messageText = responseDictionary?["error"] as? String ?? ""
                        if let errorDict = responseDictionary?["errors"] as? NSDictionary {
                            if let valueArray = errorDict.allValues.first as? [String] {
                                messageText = valueArray.first ?? ""
                            }
                        } else if let errorDict = responseDictionary?["error"] as? NSDictionary {
                            if let messag = errorDict["messages"] as? [String] {
                                messageText = messag.first ?? ""
                            }
                            if let messag = errorDict["messages"] as? String {
                                messageText = messag
                            }
                            if let code = errorDict["code"] as? Int, code == 401 {
                                UserDefaults.standard.clearSpecifiedItems()
                                completion(nil, nil, false, messageText)
                            }
                        }
                        messageText = messageText == "" ? responseDictionary?["message"] as? String ?? "" : messageText
                        
                        do {
                            let model = try JSONDecoder().decode(T.self, from: responseData)
                            if T.self == BasicResponse.self {
                                completion(model, responseDictionary, (messageText.lowercased().contains("success")) ? true : false,  messageText == "" ?  ErrorMessage.somethingWentWrong : messageText)
                            } else {
                                completion(model, responseDictionary, (messageText == "" || messageText.lowercased().contains("success")) ? true : false,  messageText == "" ?  ErrorMessage.somethingWentWrong : messageText)
                            }
                        } catch {
                            completion(nil, nil, false, messageText)
                        }
                    case .failure(let error):
                        completion(nil, nil, false, error.parseError() ??  ErrorMessage.somethingWentWrong)
                    }
                }
        } else {
            completion(nil, nil, false,  ErrorMessage.NetworkErrorAlert)
        }
    }
    
    func initiateMultipartFormDataAPIRequest<T: Decodable>(with url: String, method: HTTPMethod = .post, parameter: [String: Any], imageData: Data? = nil, imageName: String, decodeType: T.Type, completion: @escaping (T?, [String: Any]?, Bool, String) -> Void) {
        
        // print("[Request] :==> \(url)")
        
        if Connectivity.isConnectedToInternet() {
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in parameter {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    if imageData != nil {
                        multipartFormData.append(imageData!, withName: "file", fileName: imageName, mimeType: "image/png")
                    }
                },
                to: url, method: method , headers: getHeader())
            .responseDecodable(of: decodeType) { (response) in
                
                switch response.result {
                case .success:
                    
                    guard let responseData = response.data else {
                        completion(nil, nil, false,  ErrorMessage.somethingWentWrong)
                        return
                    }
                    
                    let _response = try? JSONSerialization.jsonObject(with: responseData, options: [])
                    let responseDictionary = _response as? [String: Any]
                    //  print("[Response] :==> \(responseDictionary ?? [:])")
                    
                    //Find error or success
                    var messageText = responseDictionary?["error"] as? String ?? ""
                    if let errorDict = responseDictionary?["errors"] as? NSDictionary {
                        if let valueArray = errorDict.allValues.first as? [String] {
                            messageText = valueArray.first ?? ""
                        }
                    } else if let errorDict = responseDictionary?["error"] as? NSDictionary {
                        if let messag = errorDict["messages"] as? [String] {
                            messageText = messag.first ?? ""
                        }
                        if let messag = errorDict["messages"] as? String {
                            messageText = messag
                        }
                    }
                    
                    do {
                        let model = try JSONDecoder().decode(T.self, from: responseData)
                        completion(model, responseDictionary, messageText == "" ? true : false,  messageText == "" ?  ErrorMessage.somethingWentWrong : messageText)
                    } catch {
                        completion(nil, nil, false, messageText)
                    }
                case .failure(let error):
                    completion(nil, nil, false, error.parseError() ??  ErrorMessage.somethingWentWrong)
                }
            }
        } else {
            completion(nil, nil, false, ErrorMessage.NetworkErrorAlert)
        }
    }
    
    private func getHeader(with isEnabled: Bool = true) -> HTTPHeaders {
        var header: HTTPHeaders = [:]
        guard isEnabled else { return header }
        
        if let token = UserDefaults.standard.token {
            header = [.authorization(bearerToken: token), .accept("application/json")]
        } else {
            header = [.accept("application/json")]
        }
        return header
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

private extension AFError {
    func parseError() -> String? {
        switch self {
        case .createUploadableFailed(let error):
            return error.localizedDescription
        case .createURLRequestFailed(let error):
            debugPrint(error)
            return error.localizedDescription
        case .downloadedFileMoveFailed(let error, let source, let destination):
            debugPrint(error)
            debugPrint(source)
            debugPrint(destination)
            return error.localizedDescription
        case .explicitlyCancelled:
            break
        case .invalidURL(let error):
            debugPrint(error)
            break
        case .multipartEncodingFailed(let error):
            debugPrint(error)
            break
        case .parameterEncodingFailed(let error):
            debugPrint(error)
            break
        case .parameterEncoderFailed(let error):
            debugPrint(error)
            break
        case .requestAdaptationFailed(let error):
            debugPrint(error)
            return error.localizedDescription
        case .requestRetryFailed(let retryError, let originalErro):
            debugPrint(retryError)
            debugPrint(originalErro)
            return retryError.localizedDescription
        case .responseValidationFailed(let error):
            debugPrint(error)
            break
        case .responseSerializationFailed(let error):
            
            debugPrint(error)
            return  ErrorMessage.somethingWentWrong
        case .serverTrustEvaluationFailed(let error):
            debugPrint(error)
            break
        case .sessionDeinitialized:
            break
        case .sessionInvalidated(let error):
            debugPrint(error ?? "")
            return error?.localizedDescription
        case .sessionTaskFailed(let error):
            debugPrint(error)
            return error.localizedDescription
        case .urlRequestValidationFailed(let error):
            debugPrint(error)
            break
        }
        return self.asAFError?.localizedDescription
    }
}

