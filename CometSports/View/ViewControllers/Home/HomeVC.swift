//
//  HomeVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import UIKit
import FSCalendar

enum HomeHeaders: String, CaseIterable {
    case hotMatch    = "Hot Matches"
    case fanZones    = "FanZones"
    case topNews     = "Top News"
    case feed        = "Feed"
    case predictions = "Predictions"
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var hiTextLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var bannerCV: UICollectionView!
    @IBOutlet weak var listTV: UITableView!
    
    var activityIndicator: ActivityIndicatorHelper!
    var sectionArray: [HomeHeaders] = []
    var hotMatchArray: [MatchList] = []
    var allHotMatchArray: [MatchList] = []
    var newsArray: [News] = []
    var forumArray: [Forum] = []
    var feedArray: [Post] = []
    var predictionArray: [Prediction] = []
    var isPagination = false //news
    var pageNum = 1
    var dayOffset = 0 // 0 -> today, -1 -> yesterday, -2 -> last two days .... max = -7
    var bannersCount = 0
    var timer = Timer()
    var loadFormsOnceMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSettingView()
    }
    
    
    // MARK: - Methods
    func configure() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        nibInitialization()
        self.getBannerList()
    }
    
    
    func configureView() {
        pageNum = 1
        hiTextLBL.text = "Hi,".localized
        if let user = UserDefaults.standard.user {
            userImageIV.setImage(imageStr: user.image, placeholder: Images.user)
            nameLBL.text = user.fullName
            sectionArray = [.hotMatch, .topNews, .fanZones, .feed, .predictions]
        } else {
            userImageIV.setImage(imageStr: "", placeholder: Images.user)
            nameLBL.text = "Guest User".localized
            sectionArray = [.hotMatch, .topNews, .fanZones, .predictions]
        }
        getMatchList()
       getCloudValues()
    }
    
    func getCloudValues() {
        NotificationViewModel.shared.getNotifications { error in
             if error != nil{
                print(error?.localizedDescription ?? "")
            }
            self.showMessageAlert()
        }
    }
    
    func showMessageAlert() {
        if let showAlert = UserDefaults.standard.showAlert, showAlert == 1 {
            let cloudDetail = NotificationViewModel.shared.notification
            showAlert1(message: cloudDetail?.message ?? "") {
                guard let url = URL(string: cloudDetail?.url ?? "") else { return }
                UIApplication.shared.open(url)
            }
        }
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "HomeHeaderTableCell", bundle: nil)
        listTV?.register(nib, forCellReuseIdentifier: "HomeHeaderTableCell")
        let nib2 = UINib(nibName: "MatchesTableCell", bundle: nil)
        listTV?.register(nib2, forCellReuseIdentifier: "MatchesTableCell")
        let nib3 = UINib(nibName: "HomeCollectionTableCell", bundle: nil)
        listTV?.register(nib3, forCellReuseIdentifier: "HomeCollectionTableCell")
        let nib4 = UINib(nibName: "EmptyTableCell", bundle: nil)
        listTV?.register(nib4, forCellReuseIdentifier: "EmptyTableCell")
        let nib5 = UINib(nibName: "ImageCollectionCell", bundle: nil)
        bannerCV.register(nib5, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    @objc func configureSettingView()  {
        //  backBTN.isHidden = !(UserDefaults.standard.showSettingBTN ?? false)
    }
    
    func getBannerList() {
        activityIndicator.startAnimaton()
        HomeViewModel.shared.getBannerList { status, errorMsg  in
            if status {
                if self.bannersCount == 0 {
                    self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.pageControllerForBanners), userInfo: nil, repeats: true)
                }
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
            self.bannerCV.reloadData()
        }
    }
    
    func getMatchList() {
        activityIndicator.startAnimaton()
        HomeViewModel.shared.getHotMatches { matches, status, errorMsg in
           // self.activityIndicator.stopAnimaton()
            self.getNewsList()
            self.allHotMatchArray = matches
            self.hotMatchArray = Array(matches.prefix(3))
            if !status {
                Toast.show(message: errorMsg, view: self.view)
            }
            //self.listTV.reloadData()
        }
    }
    
    func getNewsList() {
        //  activityIndicator.startAnimaton()
        HomeViewModel.shared.getNewsList(pageNum: pageNum, dayoffset: dayOffset) { news,status,errorMsg  in
            self.getPredictions()
            self.getForumList()
            self.activityIndicator.stopAnimaton()
            if self.pageNum == 1 {
                self.newsArray.removeAll()
            }
            if status {
                if news.count > 0 {
                    self.newsArray.append(contentsOf: news)
                    self.isPagination = false
                }
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
           // self.listTV.reloadData()
        }
    }
    
    func getForumList() {
        activityIndicator.startAnimaton()
        ForumViewModel.shared.getForums { forums, status, errorMsg in
            self.activityIndicator.stopAnimaton()
            if let user = UserDefaults.standard.user {
                self.getFeedList()
            }
            self.forumArray = Array(forums.prefix(1))
            if status {
                for (_index, forum) in self.forumArray.enumerated() {
                    self.getPostList(forumId: forum.forumUniqueID) { posts in
                        self.forumArray[_index].postList = posts
                        for post in self.forumArray[_index].postList {
                            if post.postImages?.count ?? 0 > 0 {
                                self.forumArray[_index].haveImage = true
                            }
                        }
                        self.listTV.reloadData()
                    }
                }
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
            self.listTV.reloadData()
        }
    }
    
    func getPostList(forumId: String, completion:@escaping ([Post]) -> Void) {
        // activityIndicator.startAnimaton()
        ForumViewModel.shared.getPosts(forumId: forumId) { posts, status, errorMsg in
            // self.activityIndicator.stopAnimaton()
            completion(posts)
        }
    }
    
    func getFeedList() {
        activityIndicator.startAnimaton()
        ForumViewModel.shared.getJoinedForumPost { posts, status, errorMsg in
            self.activityIndicator.stopAnimaton()
            
            self.feedArray = Array(posts.prefix(2))
            if !status {
                Toast.show(message: errorMsg, view: self.view)
            }
            self.listTV.reloadData()
        }
    }
    
    func getPredictions() {
       activityIndicator.startAnimaton()
        HomeViewModel.shared.getPredictions { predictions, status, errorMsg in
            self.activityIndicator.stopAnimaton()
            
            self.predictionArray = predictions
            if !status {
                Toast.show(message: errorMsg, view: self.view)
            }
            //  self.listTV.reloadData()
        }
    }
    
    @objc func pageControllerForBanners() {
        let dataCount = HomeViewModel.shared.bannerArray.count
        
        let count = min(dataCount, 3)
        if bannersCount < count {
            let index = IndexPath.init(row: bannersCount, section: 0)
            bannerCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        } else {
            bannersCount = 0
            let index = IndexPath.init(row: bannersCount, section: 0)
            bannerCV.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
        bannersCount = (bannersCount + 1) % dataCount
    }
    
    
    func deletePost(_index: Int) {
        showAlert2(title: "", message: ErrorMessage.deleteAlert) {
            self.activityIndicator.startAnimaton()
            let model = self.feedArray[_index]
            ForumViewModel.shared.deletePost(id: model.id ?? 0) { status, errorMsg in
                self.activityIndicator.stopAnimaton()
                if status {
                    self.getFeedList()
                } else {
                    Toast.show(message: errorMsg, view: self.view)
                }
            }
        }
    }
    
    func blockUser(userId: Int) {
        let param: [String: Any] = [
            "blocked_user_id": userId,
            "flag": "true",
            "reason": "autogenerated reason"
        ]
        
        self.activityIndicator.startAnimaton()
        ForumViewModel.shared.blockUserOrPost(type: .user, parameters: param) { status, errorMsg in
            self.activityIndicator.stopAnimaton()
            if status{
                self.getFeedList()
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
        }
    }
    
    // MARK: - Button Action
    
    @objc func seeAllBTNTapped(sender: UIButton) {
        switch sectionArray[sender.tag] {
        case .hotMatch:
            hotMatchArray = allHotMatchArray
            listTV.reloadData()
            //case .topNews:
        case .feed, .fanZones:
            if let user = UserDefaults.standard.user {
                let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "FanZoneListVC") as! FanZoneListVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else {
                self.showAlert2(title: "Login / Sign Up".localized, message: ErrorMessage.loginAlert) {
                    /// Show login page to login/register new user
                    self.presentViewController(LoginVC.self, storyboard: Storyboards.login) { vc in
                        vc.delegate = self
                    }
                }
            }
        default:
            return
        }
    }
    
    @objc func moreBTNTapped(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let user = UserDefaults.standard.user, user.id == (self.feedArray[sender.tag].user?.id ?? 0) {// app user
            let action1 = UIAlertAction(title: "Edit Post".localized, style: .default , handler:{ (UIAlertAction) in
                let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "CreatePostVC") as! CreatePostVC
                nextVC.postModel = self.feedArray[sender.tag]
                nextVC.forumUniqId = self.feedArray[sender.tag].forumUniqueID ?? ""
                nextVC.isForEdit = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Delete Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.deletePost(_index: sender.tag)
            })
            alert.addAction(action2)
        } else {
            let action1 = UIAlertAction(title: "Block User".localized, style: .default , handler:{ (UIAlertAction) in
                self.showAlert2(title: "", message: "You are about to block this user. You will no longer see their content and the user will no longer be able to see your content. Would you like to block this user?") {
                    self.blockUser(userId: self.feedArray[sender.tag].user?.id ?? 0)
                }
            })
            alert.addAction(action1)
            let action2 = UIAlertAction(title: "Report Post".localized, style: .default , handler:{ (UIAlertAction) in
                self.showAlert2(title: "", message: "You are about to report this post as malicious or abusive. Would you like to report this post to PitchStories?") {
                    let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                    nextVC.contentId = self.feedArray[sender.tag].id ?? 0
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            })
            alert.addAction(action2)
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel , handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    @objc func forumBTNTapped(sender: UIButton) {
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "FanZoneDetailVC") as! FanZoneDetailVC
        nextVC.forumModel.forumUniqueID = feedArray[sender.tag].forumUniqueID ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func joinBTNTapped(sender: UIButton) {
        if let user = UserDefaults.standard.user {
            activityIndicator.startAnimaton()
            ForumViewModel.shared.joinOrLeaveForum(forumId: forumArray[sender.tag].forumUniqueID, join: true) { status, errorMsg in
                self.activityIndicator.stopAnimaton()
                if status {
                    self.getForumList()
                } else {
                    Toast.show(message: errorMsg, view: self.view)
                }
                self.listTV.reloadData()
            }
        } else {
            self.showAlert2(title: "Login / Sign Up".localized, message: ErrorMessage.loginAlert) {
                /// Show login page to login/register new user
                self.presentViewController(LoginVC.self, storyboard: Storyboards.login) { vc in
                    vc.delegate = self
                }
            }
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if loadFormsOnceMore {
    //            loadFormsOnceMore = false
    //            getForumList()
    //        }
    //    }
}

// MARK: - CollectionView Delegates
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeViewModel.shared.bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.imageIV.setImage(imageStr: bannerImageURL + HomeViewModel.shared.bannerArray[indexPath.item].coverPath, placeholder: Images.noImage)
        return cell
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bannerMesssage = HomeViewModel.shared.bannerArray[indexPath.item].message
        if bannerMesssage.contains("http") || bannerMesssage.contains("www"){
            guard let url = URL(string: bannerMesssage) else { return }
            UIApplication.shared.open(url)
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 5)
    }
}

// MARK: - TableView Delegates
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionArray[section] {
        case .hotMatch:
            return hotMatchArray.count > 0 ? hotMatchArray.count : 1
        case .topNews, .fanZones:
            return 1
        case .feed:
            return feedArray.count > 0 ? feedArray.count : 1
        case .predictions:
            return predictionArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section] {
        case .hotMatch:
            if hotMatchArray.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesTableCell", for: indexPath) as! MatchesTableCell
                cell.setCellValues(model: hotMatchArray[indexPath.row])
                return cell
            } else {
                return getEmptyTableCell(message: ErrorMessage.matchesEmptyAlert, indexpath: indexPath)
            }
        case .topNews:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCollectionTableCell", for: indexPath) as! HomeCollectionTableCell
            cell.newsArray = newsArray
            cell.delegate = self
            cell.configure(section: .topNews)
            return cell
        case .feed:
            if feedArray.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableCell", for: indexPath) as! PostTableCell
                cell.configure(model: feedArray[indexPath.row], feedCell: true, _index: indexPath.row)
                cell.moreBTN.addTarget(self, action: #selector(moreBTNTapped(sender:)), for: .touchUpInside)
                cell.forumBTN.addTarget(self, action: #selector(forumBTNTapped(sender:)), for: .touchUpInside)
                return cell
            } else {
                return getEmptyTableCell(message: ErrorMessage.dataEmptyAlert, indexpath: indexPath)
            }
        case .fanZones:
            if forumArray.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FanZoneTableCell", for: indexPath) as! FanZoneTableCell
                cell.configure(model: forumArray[indexPath.row], _index: indexPath.row)
                cell.joinBTN.addTarget(self, action: #selector(joinBTNTapped(sender:)), for: .touchUpInside)
                return cell
            } else {
                return getEmptyTableCell(message: ErrorMessage.dataEmptyAlert, indexpath: indexPath)
            }
        case .predictions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionTableCell", for: indexPath) as! PredictionTableCell
            cell.configure(model: predictionArray[indexPath.row])
            return cell
        }
    }
    
    func getEmptyTableCell(message: String, indexpath: IndexPath) -> UITableViewCell {
        let cell = listTV.dequeueReusableCell(withIdentifier: "EmptyTableCell", for: indexpath) as! EmptyTableCell
        cell.titleLBL.text = message.localized
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section] {
        case .hotMatch:
            let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "AiScoreMatchDetailVC") as! AiScoreMatchDetailVC
            nextVC.match = hotMatchArray[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case .predictions:
            let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "PredictionDetailVC") as! PredictionDetailVC
            nextVC.predictionModel = predictionArray[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case .fanZones:
            let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "FanZoneDetailVC") as! FanZoneDetailVC
            nextVC.forumModel.forumUniqueID = forumArray[indexPath.row].forumUniqueID
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableCell") as! HomeHeaderTableCell
        headerView.configure(section: sectionArray[section], tag: section)
        headerView.seeAllBTN.addTarget(self, action: #selector(seeAllBTNTapped(sender:)), for: .touchUpInside)
        if section == 0 && allHotMatchArray.count <= 3 {
            headerView.seeAllBTN.isHidden = true
        } else {
            headerView.seeAllBTN.isHidden = headerView.seeAllBTN.isHidden
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (UserDefaults.standard.user == nil) && sectionArray[section] == .feed {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sectionArray[indexPath.section] {
        case .hotMatch:
            return 130
        case .topNews:
            return 240
        case .fanZones:
            return UITableView.automaticDimension //450
        case .feed, .predictions:
            return UITableView.automaticDimension
        }
    }
}

extension HomeVC: HomeCollectTVCellDelegate {
    func moreBTNTapped(_index: Int) {}
    
    func newsSelected(id: Int) {
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        nextVC.newsId = "\(id)"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func newsPagination() {
        if !isPagination {
            isPagination = true
            pageNum = pageNum + 1
            self.getNewsList()
        }
    }
}

// MARK: - Custom Delegate
extension HomeVC: LoginVCDelegate {
    func viewControllerDismissed() {
        configureView()
    }
}
