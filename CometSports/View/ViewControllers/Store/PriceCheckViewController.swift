//
//  PriceCheckViewController.swift
//  Comet Sports
//
//  Created by iosDev on 7/28/23.
//

import UIKit

class PriceCheckViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var youSearchedForLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var howItWorksView: UIView!
    @IBOutlet weak var searchedContentView: UIView!
    @IBOutlet weak var emptyLBL: UILabel!
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var howItWorkLBL: UILabel!
    @IBOutlet weak var howItUseLBL: UILabel!
    @IBOutlet weak var howItWorkDetailLBL: UILabel!
    @IBOutlet weak var howItUseDetailLBL: UILabel!
    
    var statsCellDelegate:ShortStatsUpdateDelegate?
    var graphsCellDelegate:GraphsCellDelegate?
    
    var viewModel=ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        tableView.register(UINib(nibName: "PriceCheckProductCoverCell", bundle: nil), forCellReuseIdentifier: "imageBanner")
        tableView.register(UINib(nibName: "ShortStatsTableViewCell", bundle: nil), forCellReuseIdentifier: "shortStats")
        tableView.register(UINib(nibName: "GraphsTableViewCell", bundle: nil), forCellReuseIdentifier: "Graphs")
        
        viewModel.delegate=self
        self.youSearchedForLabel.text = "You searched for ".localized + self.searchField.text!
        searchButton.setOnClickListener {
            
            self.searchField.resignFirstResponder()
            self.youSearchedForLabel.text = "You searched for ".localized + self.searchField.text!
            
            guard !self.searchField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                self.viewModel.productsMasterList.removeAll()
                self.emptyLBL.isHidden = true
                self.searchedContentView.isHidden=true
                self.howItWorksView.isHidden = false
                return
            }
            self.viewModel.getAllProductsForSearch(searchText: self.searchField.text?.addingPercentEncoding( withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "")
            Utility.showProgress(message: "Searching For Your Items".localized)
            self.statsCellDelegate?.starLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emptyLBL.isHidden = true
        headerLBL.text = "Price Check".localized
        searchField.placeholder = "Search for products here".localized
        searchButton.setTitle("Search".localized, for: .normal)
        emptyLBL.text = ErrorMessage.dataEmptyAlert.localized
        howItWorkLBL.text = "How It Works".localized
        howItUseLBL.text = "How To Use".localized
        howItWorkDetailLBL.text = "1: We take the keyword you entered\n2: Keyword is handed to an ML Model\n3: Model analyzes the database for all related products\n4: API returns results with all the comparative results\n5: Deep analysis on the products is performed\n6: We display results with interactive UIs".localized
        howItUseDetailLBL.text = "1: Enter the desired product in search box\n2: Wait for the system to return results\n3: Browse the results and make wise choices\n4: For example: Nike, Adidas, etc.".localized
        tableView.reloadData()
        
    }
    // MARK: - Button Actions
    @objc func mostExpCellBTNTapped() {
        if let prodModel = viewModel.mostExpensiveProduct {
            let nextVC = Storyboards.store.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailVC
            nextVC.productId = prodModel.id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func cheapestCellBTNTapped() {
        if let prodModel = viewModel.cheapestProduct {
            let nextVC = Storyboards.store.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailVC
            nextVC.productId = prodModel.id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @objc func seeAllCellBTNTapped() {
        let nextVC = Storyboards.store.instantiateViewController(withIdentifier: "StoreVC") as! StoreVC
        nextVC.searchText = searchField.text!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - ProductViewModel Delegates
extension PriceCheckViewController:ProductViewModelDelegate{
    func averageAdded() {
        graphsCellDelegate?.updateLineGraph(numbers: viewModel.averageForEachPage)
    }
    
    func pricesSorted() {
        statsCellDelegate?.updateCell(expensive: viewModel.mostExpensiveProduct, cheap: viewModel.cheapestProduct, average: "100")
    }
    
    func newDataAvailable() {
        howItWorksView.isHidden=true
        searchedContentView.isHidden=false
        tableView.reloadData()
    }
    
    func dataFetchFinished() {
        configureEmptyView()
        statsCellDelegate?.updateFinished()
        Utility.dismissProgress()
    }
    
    func startConcurrentExecution() {
        searchedContentView.isHidden=false
        Utility.dismissProgress()
    }
    
    func errorInFetchingData() {
        configureEmptyView()
    }
    
    func tagsSorted() {
        graphsCellDelegate?.updateBarGraph(data: viewModel.keywordsCount)
    }
    func configureEmptyView() {
        howItWorksView.isHidden = searchField.text != ""
        emptyLBL.isHidden = viewModel.productsMasterList.count != 0
        searchedContentView.isHidden = viewModel.productsMasterList.count == 0
    }
    
}

// MARK: - TableView Delegates
extension PriceCheckViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageBanner") as! PriceCheckProductCoverCell
            if viewModel.productsMasterList.count>3{
                cell.configureCell(link1: viewModel.productsMasterList[0].coverPath, link2: viewModel.productsMasterList[1].coverPath, link3: viewModel.productsMasterList[2].coverPath, link4: viewModel.productsMasterList[3].coverPath)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "shortStats") as! ShortStatsTableViewCell
            statsCellDelegate=cell
            cell.buttonMostExp.addTarget(self, action: #selector(mostExpCellBTNTapped), for: .touchUpInside)
            cell.cheapestButton.addTarget(self, action: #selector(cheapestCellBTNTapped), for: .touchUpInside)
            cell.seeAllBTN.addTarget(self, action: #selector(seeAllCellBTNTapped), for: .touchUpInside)
            cell.configureCell(expensive: viewModel.mostExpensiveProduct ?? Product(), cheap: viewModel.cheapestProduct ?? Product(), average: "100")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Graphs") as! GraphsTableViewCell
            graphsCellDelegate=cell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "shortStats") as! ShortStatsTableViewCell
            statsCellDelegate=cell
            cell.buttonMostExp.addTarget(self, action: #selector(mostExpCellBTNTapped), for: .touchUpInside)
            cell.cheapestButton.addTarget(self, action: #selector(cheapestCellBTNTapped), for: .touchUpInside)
            cell.seeAllBTN.addTarget(self, action: #selector(seeAllCellBTNTapped), for: .touchUpInside)
            cell.configureCell(expensive: viewModel.mostExpensiveProduct ?? Product(), cheap: viewModel.cheapestProduct ?? Product(), average: "100")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row==2{
            return tableView.bounds.width * (16/9)
        }else if indexPath.row==0{
            return tableView.bounds.width * (3/4)
        }else{
            return tableView.bounds.width * (3/4) + 100
        }
    }
}

// MARK: - TextField Delegates
extension PriceCheckViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
