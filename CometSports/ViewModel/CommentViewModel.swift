//
//  CommentViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 24/02/2024.
//

import Foundation

class CommentVM: NSObject {
    
    static let shared = CommentVM()
    
    func getComments(id: String, completion:@escaping ([Comment], Bool, String) -> Void) {
        let url = URLs.commentList + "?comment_section_id=\(id)"
        NetworkManager.shared.initiateAPIRequest(with: url, method: .get, encoding: .URLEncoding, decodeType: CommentResponse.self) { model, responseDict, status, message in
            if let data = model?.response?.data {
                completion(data, true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func addComment(parameters: [String: Any], completion:@escaping (Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.addComment, parameter: parameters, decodeType: BasicResponse.self) { model, responseDict, status, message in
            if let data = model?.response {
                completion(true, "")
            } else {
                completion(false, message)
            }
        }
    }
    
    func deleteComment(commentId: Int, completion:@escaping (Bool, String) -> Void) {
          NetworkManager.shared.initiateAPIRequest(with: "\(URLs.deleteComment)/\(commentId)", method: .delete, decodeType: BasicResponse.self) { model, responseDict, status, message in
            if let data = model?.response {
                completion(true, "")
            } else {
                completion(false, message)
            }
        }
    }
}

