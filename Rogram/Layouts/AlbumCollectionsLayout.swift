//
//  AlbumCollectionsLayout.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

class AlbumCollectionsLayout: UICollectionViewLayout {
    
    private let itemSize: CGSize
    
    // MARK: TODO -> We may be able to remove this and use contentWidth directly?
    private let totalWidth: CGFloat
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    init(itemSize: CGSize, totalWidth: CGFloat) {
        self.itemSize = itemSize
        self.totalWidth = totalWidth
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        let numberOfSections = collectionView.numberOfSections
        let numberOfItems = collectionView.numberOfItems(inSection: numberOfSections - 1)
        
        var yOffset: CGFloat = 25
        let spacing: CGFloat = 25
        
        let numberOfItemsPerRow: CGFloat = 2
        
        let availableWidth = totalWidth - ((numberOfItemsPerRow * itemSize.width) + spacing)
        var xOffset: CGFloat = availableWidth / 2
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: numberOfSections - 1)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if item != 0 && item % Int(numberOfItemsPerRow) == 0 {
                xOffset = availableWidth / 2
                yOffset += itemSize.height + spacing
            }
            
            let frame = CGRect(
                x: xOffset,
                y: yOffset,
                width: itemSize.width,
                height: itemSize.height
            )
            
            attributes.frame = frame
            xOffset = frame.maxX + spacing
            cache.append(attributes)
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
