//
//  FeaturedPostsLayout.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

class FeaturedPostsLayout: UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        let numberOfSections = collectionView.numberOfSections
        let numberOfItems = collectionView.numberOfItems(inSection: numberOfSections - 1)
        
        let horizontalInsets: CGFloat = 48
        let verticalSpacing: CGFloat = 25
        var yOffset: CGFloat = 16
        let itemSize = CGSize(width: UIScreen.main.bounds.width - (horizontalInsets * 2), height: 400)
        
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: numberOfSections - 1)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let frame = CGRect(
                x: horizontalInsets,
                y: yOffset,
                width: itemSize.width,
                height: itemSize.height
            )

            attributes.frame = frame
            
            cache.append(attributes)
            yOffset += itemSize.height + verticalSpacing
            contentHeight = frame.maxY
        }
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
        
        return cache.first { $0.indexPath == indexPath }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        
        return cache.filter { $0.frame.intersects(rect) }
    }
}
