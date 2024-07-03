
import Foundation

let baseURL                         = "https://sportsapi3.com/"
let socialBaseURL                   = baseURL + "forums/"
let aiScoreBaseURL                  = baseURL + "sportsapi/api/"
let predictionBaseURL               = baseURL + "rd-prj/"
let photoImageURL                   = "https://api996.com/"
var photoURL                        = ""

struct URLs {
    
    static let appReview            = "itms-apps://itunes.apple.com/app/id\(appStoreID)?mt=8&action=write-review"
    static let privacyPolicy        = baseURL + "prjdocs/comet-sports/privacypolicy.html"
    static let terms                = baseURL + "prjdocs/comet-sports/term&conditions.html"
    static let contactUs            = baseURL + "prjdocs/comet-sports/contactus.html"
    
    //Login
    static let login                = socialBaseURL + "api/auth/login"
    static let register             = socialBaseURL + "api/auth/signup"

    //Image
    static let postImage            = socialBaseURL + "api/resource/upload"
    
    //Profile
    static let user                 = socialBaseURL + "api/auth/user"
    static let updateUser           = socialBaseURL + "api/user/profile"
    static let blockUser            = socialBaseURL + "api/user/block"
    
    //Forum
    static let allForums            = socialBaseURL + "api/forum/all?app=comet"
    static let joinedForums         = socialBaseURL + "api/forum/list/joined"
    static let forumDetail          = socialBaseURL + "api/forum/details/"
    static let forumJoin            = socialBaseURL + "api/forum/join"
    static let forumLeave           = socialBaseURL + "api/forum/leave"
    static let joinedForumPost      = socialBaseURL + "api/post/joined-forum-posts"
    static let postList             = socialBaseURL + "api/post/list"
    static let post                 = socialBaseURL + "api/post"
    static let blockPost            = socialBaseURL + "api/post/block"

    //Prediction
    static let prediction           = predictionBaseURL + "api/prediction/popular/match/top/prediction/list?skippopular=true"
    
    //News
    static let news                 = baseURL + "sevenfive/api/post-list/"
    static let newsDetail           = baseURL + "sevenfive/api/post/"
    
    //Comments
    static let commentList          = socialBaseURL + "api/user/comment/list"
    static let addComment           = socialBaseURL + "api/user/comment/add"
    static let deleteComment        = socialBaseURL + "api/user/comment/delete"
    
    //Match
    static let match                = baseURL + "app8/api/v1/sportscore/data/" + "match.php"
    
    //New Match APIs
    
    static let footballMatches      = aiScoreBaseURL + "football/matchlist/today"
    static let footballPastMatch    = aiScoreBaseURL + "football/matchlist/past/"
    static let footballH2HMatchList = aiScoreBaseURL + "football/match-analysis/statics/"
    
    //Analyst and Analysis
    static let analystList          = baseURL + "encapi?data=piM3AmVV9RWALDppauz2sxkKnORDJf9Gjxm6P5G59Ck="
    static let analystDetail        = baseURL + "encapi?data=piM3AmVV9RWALDppauz2s5geRo/9TLFKtJQnLnTCGFOAsO3iVXrDpP3+YHwiaF4o"
    static let analysis             = baseURL + "encapi?data=7tfJZojAlwP/X7OlJrkaSgEcX4h0EIpzdGe+ftJq3GDANu3mWDKLN+aMQ2yCp9dZ"
    
    //Product
    static let productList          = baseURL + "xn/api/v1/product-list/"
    static let productSearch        = baseURL + "xn/api/v1/product-list-search/"
    static let productListTag       = baseURL + "xn/api/v1/product-list-by-tag/"
    static let productDetail        = baseURL + "xn/api/v1/product-info/"
    static let productImage         = baseURL + "xn/"
   
}
