//
//  AlbumCollectionViewCell.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: AlbumCollectionViewCell.self)
    }
    
    private var displayLink: CADisplayLink?
    public var posts: [Post] = [] {
        didSet {
            nestedCollectionView.reloadData()
        }
    }
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    
    public lazy var nestedCollectionView: UICollectionView = {
        let totalWidth: CGFloat = 160

        let itemSize = CGSize(width: 50, height: 80)
        let layout = AlbumCollectionsLayout(itemSize: itemSize, totalWidth: totalWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(NestedAlbumCollectionViewCell.self, forCellWithReuseIdentifier: NestedAlbumCollectionViewCell.identifier)
        startAnimatingContentOffset()
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateContentOffset() {
        let offsetY = nestedCollectionView.contentOffset.y + 0.25
        let visibleHeight = nestedCollectionView.bounds.height
        nestedCollectionView.contentOffset = CGPoint(x: 0, y: offsetY)
        
        if offsetY >= nestedCollectionView.contentSize.height - (visibleHeight - 50) {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.nestedCollectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}

private extension AlbumCollectionViewCell {
    
    func setup() {
        contentView.addSubview(containerView)
        containerView.addSubview(nestedCollectionView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            nestedCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nestedCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nestedCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nestedCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    func startAnimatingContentOffset() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateContentOffset))
        displayLink?.add(to: .main, forMode: .common)
    }
}

extension AlbumCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(posts.count, 10) // Limiting to 10 to improve performance while still having access to full collection of posts 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NestedAlbumCollectionViewCell.identifier, for: indexPath) as? NestedAlbumCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
