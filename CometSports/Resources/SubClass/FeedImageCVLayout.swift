//
//  FeedImageCVLayout.swift
//  Comet Sports
//
//  Created by iosDev on 19/02/2024.
//

import UIKit

class FeedImageCVLayout: UICollectionViewLayout {
    var height = Int(screenWidth - 50)
    // 2
    var layoutType = 0
    fileprivate var cellPadding: CGFloat = 1
    
    // 3
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    // 4
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        //let insets = collectionView.contentInset
        return CGFloat(height)//screenWidth - 50
    }
    
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: height, height: height) //CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        contentHeight = CGFloat(height)
        
        // 1
        cache = []
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            var frame = CGRect()
            
            switch layoutType{
            case 1:
                frame = CGRect(x: 0, y: 0, width: Int(contentWidth), height: height)
            case 2:
                if indexPath.row == 0{
                    frame = CGRect(x: 0, y: 0, width: Int(contentWidth/2), height: height)
                }else{
                    frame = CGRect(x: Int(contentWidth/2), y: 0, width: Int(contentWidth/2), height: height)
                }
            case 3:
                switch indexPath.row{
                case 0:
                    frame = CGRect(x: 0, y: 0, width: Int(contentWidth), height: height/2)
                case 1:
                    frame = CGRect(x: 0, y: (height/2), width: (Int(contentWidth) / 2), height: height/2)
                case 2:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/2), width: Int(contentWidth) / 2, height: (height/2))
                default:
                    break
                }
            case 4:
                switch indexPath.row{
                case 0:
                    frame = CGRect(x: 0, y: 0, width: (Int(contentWidth) / 2), height: (height/2) )
                case 1:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: 0, width: (Int(contentWidth) / 2), height: (height/2))
                case 2:
                    frame = CGRect(x: 0, y: (height/2), width: (Int(contentWidth) / 2), height: (height/2))
                case 3:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/2), width: (Int(contentWidth) / 2), height: (height/2))
                default:
                    break
                }
            case 5:
                switch indexPath.row{
                case 0:
                    frame = CGRect(x: 0, y: 0, width: Int(contentWidth) / 2, height: (height/2) )
                case 1:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: 0, width: Int(contentWidth) / 2, height: (height/3))
                case 2:
                    frame = CGRect(x: 0, y: (height/2), width: Int(contentWidth) / 2, height: (height/2))
                case 3:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/3), width: Int(contentWidth) / 2, height: (height/3))
                case 4:
                    frame = CGRect(x: (Int(contentWidth) / 2), y: (height/3)*2, width: Int(contentWidth) / 2, height: (height/3))
                default:
                    break
                }
            default:
                
                break
            }
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}



