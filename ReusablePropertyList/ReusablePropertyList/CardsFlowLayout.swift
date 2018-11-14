//
//  CardsFlowLayout.swift
//  ReusablePropertyList
//
//  Created by Felipe Lefèvre Marino on 11/13/18.
//  Copyright © 2018 Zap SA Internet. All rights reserved.
//

import UIKit

protocol CardsLayoutDelegate: class {
    var numberOfHorizontalVisibleCards: Int {get}
    var numberOfVerticalVisibleCards: Int {get}
    var scrollDirection: UICollectionView.ScrollDirection {get}
}

class CardsFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: CardsLayoutDelegate!
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var cellPadding: CGFloat = 6
    
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        guard scrollDirection == .vertical else { return collectionHeight }
        
        let cardsByPage = numberOfCardsByRow * numberOfCardsByColumn
        let numberOfPages = CGFloat(collectionView.numberOfItems(inSection: 0)) / CGFloat(cardsByPage)
        return collectionHeight * numberOfPages
    }
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        guard scrollDirection == .horizontal else { return collectionWidth }
        
        let cardsByPage = numberOfCardsByRow * numberOfCardsByColumn
        let numberOfPages = CGFloat(collectionView.numberOfItems(inSection: 0)) / CGFloat(cardsByPage)
        return collectionWidth * numberOfPages
    }
    
    private var collectionHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    private var collectionWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var numberOfCardsByRow: Int {
        return delegate.numberOfHorizontalVisibleCards
    }
    private var numberOfCardsByColumn: Int {
        return delegate.numberOfVerticalVisibleCards
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        self.scrollDirection = delegate.scrollDirection
        
        let columnWidth = collectionWidth / CGFloat(numberOfCardsByRow)
        
        let numberOfColumns = scrollDirection == .vertical ? numberOfCardsByRow : collectionView.numberOfItems(inSection: 0) / numberOfCardsByColumn
        
        var xOffset = [CGFloat]()
        
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        let rowHeight = collectionHeight / CGFloat(numberOfCardsByColumn)
        
        let numberOfRows = scrollDirection == .horizontal ? numberOfCardsByColumn : collectionView.numberOfItems(inSection: 0) / numberOfCardsByRow
        
        var yOffset = [CGFloat]()
        for row in 0 ..< numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var column = 0
        var row = 0
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let frame = CGRect(x: xOffset[column], y: yOffset[row], width: columnWidth, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            if scrollDirection == .vertical {
                column = column < (numberOfCardsByRow - 1) ? (column + 1) : 0
                row += column == 0 ? 1 : 0
            } else {
                row = row < (numberOfCardsByColumn - 1) ? (row + 1) : 0
                column += row == 0 ? 1 : 0
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
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
