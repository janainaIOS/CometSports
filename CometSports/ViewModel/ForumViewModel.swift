//
//  ForumViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 27/02/2024.
//

import Foundation

enum ReportType {
    case user
    case post
}

class ForumViewModel: NSObject {
    
    static let shared = ForumViewModel()
    
    func getForums(notJoined:Bool = true, completion:@escaping ([Forum], Bool, String) -> Void) {
        var parameters: [String: Any] = [:]
        if notJoined {
            parameters.updateValue(true, forKey: "not_joined")
        }
       
        NetworkManager.shared.initiateAPIRequest(with: URLs.allForums, method: .get, parameter: parameters, encoding: .URLEncoding, decodeType: ForumListResponse.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                 var forums = data.data ?? []
                forums.mapProperty(\.hasJoined, false)
                forums = forums.filter({$0.forumUniqueID != "MyTeam"})
                completion(forums, true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func forumDetail(id: String, completion:@escaping (Forum, Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: URLs.forumDetail + id, method: .get, encoding: .URLEncoding, decodeType: ForumResponse.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                completion(data.data ?? Forum(), true, "")
            } else {
                completion(Forum(), false, message)
            }
        }
    }
    
    func getJoinedForums(completion:@escaping ([JoinedForum], Bool, String) -> Void) {
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.joinedForums, method: .get, encoding: .URLEncoding, decodeType: JoinedForumResponse.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                var forums = data.data ?? []
                forums.mapProperty(\.forum.hasJoined, true)
                completion(forums, true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func joinOrLeaveForum(forumId: String, join: Bool, completion:@escaping (Bool, String) -> Void) {
        
        let parameters: [String: Any] = ["forum_unique_id": forumId]
        
        NetworkManager.shared.initiateAPIRequest(with: join ? URLs.forumJoin : URLs.forumLeave, parameter: parameters, decodeType: BasicResponse2.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                completion(true, "")
            } else {
                completion(false, message)
            }
        }
    }
    
    func getJoinedForumPost(completion:@escaping ([Post], Bool, String) -> Void) {
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.joinedForumPost, method: .get, encoding: .URLEncoding, decodeType: PostListResponse.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                completion(data.data ?? [], true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func calculatePostHeight(post: Post?) -> CGFloat {
        var contentText = ""
        if let content = post?.contentHTML?.attributedHtmlString {
            contentText = content.string
        }
        let titleHeight = post?.title?.heightOfString2(width: screenWidth - 70, font: appFontMedium(14)) ?? 0
        let contentHeight = contentText.heightOfString2(width: screenWidth - 70, font: appFontRegular(14)) 
        let imageHeight = post?.postImages?.count == 0 ? 0 : 150
        return titleHeight + contentHeight + CGFloat(imageHeight) + 100
    }
    
    func calculateTotalCVHeight(posts: [Post]) -> CGFloat {
        var totalHeight: CGFloat = 0
        for post in posts {
            totalHeight = totalHeight + calculatePostHeight(post: post)
        }
        return totalHeight
    }
    
    func getPosts(forumId: String, completion:@escaping ([Post], Bool, String) -> Void) {
        
        let parameters: [String: Any] = ["forum_unique_id": forumId]
        
        NetworkManager.shared.initiateAPIRequest(with: URLs.postList, method: .get, parameter: parameters, encoding: .URLEncoding, decodeType: PostListResponse.self) { model, responseDict, status, message in
            
            if let data = model?.response {
                completion(data.data ?? [], true, "")
            } else {
                completion([], false, message)
            }
        }
    }
    
    func addEditPost(isForEdit:Bool, postId:Int, parameters: [String: Any], onCompletion:@escaping (Bool, String) -> Void) {
        let url = isForEdit ? URLs.post + "/\(postId)": URLs.post
        NetworkManager.shared.initiateAPIRequest(with: url, method: isForEdit ? .put : .post, parameter: parameters, decodeType: PostResponse.self) { model, responseDict, status, message in
            if let data = model?.response {
                onCompletion(true, message)
            } else {
                onCompletion(false, message)
            }
        }
    }
    
    
    func deletePost(id:Int, onCompletion:@escaping (Bool, String) -> Void) {
        let url = URLs.post + "/\(id)"
        NetworkManager.shared.initiateAPIRequest(with: url, method: .delete, parameter: [:], decodeType: BasicResponse.self) { model, responseDict, status, message in
            if let data = model?.response {
                onCompletion(true, message)
            } else {
                onCompletion(false, message)
            }
        }
    }
    
    func blockUserOrPost(type: ReportType, parameters: [String: Any], onCompletion:@escaping (Bool, String) -> Void) {
        var url = URLs.blockUser
        switch type {
        case .post:
            url = URLs.blockPost
        default:
            url = URLs.blockUser
        }
        NetworkManager.shared.initiateAPIRequest(with: url, method: .post, parameter: parameters, decodeType: BasicResponse.self) { model, responseDict, status, message in
            if let data = model?.response {
                onCompletion(true, message)
            } else {
                onCompletion(false, message)
            }
        }
    }
}
