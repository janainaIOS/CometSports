//
//  ProductViewModel.swift
//  Comet Sports
//
//  Created by iosDev on 31/05/2023.
//

import Foundation

protocol ProductViewModelDelegate{
    func newDataAvailable()
    func dataFetchFinished()
    func startConcurrentExecution()
    func errorInFetchingData()
    func tagsSorted()
    func pricesSorted()
    func averageAdded()
}

class ProductViewModel: NSObject {
    
    static let shared = ProductViewModel()
    
    var keywordsCount = [String:Int]()
    var productsMasterList:[Product] = []
    var delegate:ProductViewModelDelegate?
    var cheapestProduct:Product?
    var mostExpensiveProduct:Product?
    var averagePriceForProduct="0"
    var averageForEachPage:[Float]=[]
    private var pageNum=1
    var timer:Timer?
    func getAllProductsForSearch(searchText: String) {
        productsMasterList.removeAll()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.delegate?.startConcurrentExecution()
        }
           fetchDataWithPagination(searchText: searchText, pageNum: 1)
  
    }
    
    func fetchDataWithPagination(searchText:String,pageNum: Int) {
    
        getProductList(searchText: searchText, pageNum: pageNum, completion: { [self] products, status, errorString in
            if status {
                if products.count > 0 {
                    productsMasterList.append(contentsOf: products)
                    delegate?.newDataAvailable()
                    sortTags(products: products)
                    sortPricing(products: products)
                    addAverageForEachPage(products: products)
                    fetchDataWithPagination(searchText: searchText,pageNum: pageNum + 1)
                } else {
                    timer?.invalidate()
                    delegate?.dataFetchFinished()
                }
            } else {
                timer?.invalidate()
                delegate?.errorInFetchingData()
            }
        })
    }
    func getProductList(searchText: String, pageNum: Int, completion:@escaping ([Product], Bool, String) -> Void) {
        let url = searchText.count > 1 ? URLs.productSearch : URLs.productList
        NetworkManager.shared.initiateAPIRequest(with: "\(url)web/\((selectedLang == .zh ? "cn" : String(describing: selectedLang)))\(searchText.count > 1 ? "/\(searchText)" : "")/\(pageNum)", method: .get, parameter: [:], encoding: .URLEncoding, decodeType: ProductListResponse.self) { model, responseDict, status, message in
            let errorMessage = message == "" ? ErrorMessage.somethingWentWrong : message
            if let data = model?.data {
                completion(data, true, "")
            } else {
                completion([], false, errorMessage)
            }
        }
    }
    
    func getProductDetail(id: Int, completion:@escaping (Product, Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: "\(URLs.productDetail)web/\((selectedLang == .zh ? "cn" : String(describing: selectedLang)))/\(id)", method: .get, parameter: [:], encoding: .URLEncoding, decodeType: ProductResponse.self) { model, responseDict, status, message in
            let errorMessage = message == "" ? ErrorMessage.somethingWentWrong : message
            if let data = model?.data {
                completion(data, true, "")
            } else {
                completion(Product(), false, errorMessage)
            }
        }
    }
    
    func getProductsByTag(id: Int, pageNum: Int, completion:@escaping ([Product], Bool, String) -> Void) {
        NetworkManager.shared.initiateAPIRequest(with: "\(URLs.productListTag)web/\((selectedLang == .zh ? "cn" : String(describing: selectedLang)))/\(id)/\(pageNum)", method: .get, parameter: [:], encoding: .URLEncoding, decodeType: ProductListResponse.self) { model, responseDict, status, message in
            let errorMessage = message == "" ? ErrorMessage.somethingWentWrong : message
            if let data = model?.data {
                completion(data, true, "")
            } else {
                completion([], false, errorMessage)
            }
        }
    }
    func sortTags(products:[Product]){
        var allTags = [String]()
        products.forEach{product in
            allTags.append(contentsOf:product.keywords.components(separatedBy: ","))
        }
        allTags.forEach{ key in
            if keywordsCount.keys.contains(key){
                keywordsCount[key] = (keywordsCount[key] ?? 0)+1
            }else{
                keywordsCount[key] = 1
            }
        }
        delegate?.tagsSorted()
    }
    
    
    
    func sortPricing(products:[Product]){
        products.forEach{product in
            if (cheapestProduct != nil) {
                let currentPrice =  Float(cheapestProduct?.price ?? "0.0") ?? 0.0
                let newPrice = Float(product.price) ?? 0.0
                if currentPrice>newPrice{
                    cheapestProduct=product
                }
            }else{
                cheapestProduct=product
            }
            if (mostExpensiveProduct != nil) {
                let currentPrice =  Float(mostExpensiveProduct?.price ?? "0.0") ?? 0.0
                let newPrice = Float(product.price) ?? 0.0
                if currentPrice<newPrice{
                    mostExpensiveProduct=product
                }
            }else{
                mostExpensiveProduct=product
            }
        }
        delegate?.pricesSorted()
    }
    func addAverageForEachPage(products:[Product]){
        var total=Float(0.0)
        products.forEach{ product in
            total=(Float(product.price) ?? 0.0) + total
        }
        averageForEachPage.append(total/Float(products.count))
        delegate?.averageAdded()
    }
}
