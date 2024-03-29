//
//  CenterAlignedCollectionViewFlowLayout.swift
//  Comet Sports
//
//  Created by iosDev on 04/03/2024.
//

import UIKit

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let oldAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let attributes = oldAttributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        // We will do centering alignment only on the Cell layout attributes
        let cellAttributes = attributes.filter({ (layout: UICollectionViewLayoutAttributes) -> Bool in
            return layout.representedElementCategory == .cell
        })
        
        let attributesForRows: [[UICollectionViewLayoutAttributes]] = groupLayoutAttributesByRow(cellAttributes)
        
        for attributesInRow in attributesForRows {
            let sortedItem = attributesInRow.sorted(by: { $0.frame.minX < $1.frame.minX })
            
            // Layout this row layout attributes with spacing equals to layout's `minimumInteritemSpacing`.
            sortedItem.first?.frame.origin.x = 0.0
            let (neighborsElements) = zip(sortedItem.dropLast(), sortedItem.dropFirst())
            for neighborsElement in neighborsElements {
                neighborsElement.1.frame.origin.x = neighborsElement.0.frame.maxX + self.minimumInteritemSpacing
            }
            
            let (minX, maxX) = attributesInRow.reduce((CGFloat.greatestFiniteMagnitude, CGFloat.leastNormalMagnitude), { (value, attributes) -> (CGFloat, CGFloat) in
                return (min(value.0, attributes.frame.minX), max(value.1, attributes.frame.maxX))
            })
            
            let cellViewPortWidth = maxX - minX
            // Calculate the offset of this row, and apply it to this row's layout attributes to make them center aligned
            let offset = floor((self.collectionViewContentSize.width - cellViewPortWidth) / 2)
            attributesInRow.forEach({
                $0.frame.origin.x += offset
            })
        }
        
        return attributes
    }
}

/// A simple data structure to represent the row of UICollectionViewCell layout attributes.
/// Consist of top Y position and the height of this row
private struct RowAttributes {
    var y: CGFloat
    var height: CGFloat
    
    func contains(_ rect: CGRect) -> Bool {
        return rect.maxY > self.y && rect.minY < (self.y + self.height)
    }
    func attributeByUnionRect(_ rect: CGRect) -> RowAttributes {
        let y = min(self.y, rect.minY)
        let height = max(self.height + self.y, rect.maxY) - y
        return RowAttributes(y: y, height: height)
    }
}

/// Calculate the row attributes for row of the given layout attributes by walking through the array of layout attributes
private func rowAttributesOfAttributesSameRowAs(_ layoutAttributes: UICollectionViewLayoutAttributes, byAttributes attributes: [UICollectionViewLayoutAttributes]) -> RowAttributes {
    let seedRowAttributes = RowAttributes(y: layoutAttributes.frame.minY, height: layoutAttributes.frame.height)
    return  attributes.reduce(seedRowAttributes, { (attribute, layoutAttributes) -> RowAttributes in
        if attribute.contains(layoutAttributes.frame) {
            return attribute.attributeByUnionRect(layoutAttributes.frame)
        } else {
            return attribute
        }
    })
}

/// Grouping the layout attributes by their row
private func groupLayoutAttributesByRow(_ layoutAttributes: [UICollectionViewLayoutAttributes]) -> [[UICollectionViewLayoutAttributes]] {
    var groupedLayoutAttributes = [[UICollectionViewLayoutAttributes]]()
    var remainingLayoutAttributes = layoutAttributes
    while let attributes = remainingLayoutAttributes.first {
        let attributes = rowAttributesOfAttributesSameRowAs(attributes, byAttributes: remainingLayoutAttributes)
        let classifiedRects = remainingLayoutAttributes.filter{ attributes.contains($0.frame) }
        groupedLayoutAttributes.append(classifiedRects)
        
        remainingLayoutAttributes = remainingLayoutAttributes.filter{ !attributes.contains($0.frame) }
    }
    
    return groupedLayoutAttributes
}

