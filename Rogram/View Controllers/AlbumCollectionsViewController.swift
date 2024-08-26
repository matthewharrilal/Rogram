//
//  AlbumCollectionsViewController.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

// MARK: TODO -> Rename this graph of dependencies and it's naming
class AlbumCollectionsViewController: UIViewController {
    
    private let albumService: AlbumFetcherProtocol
    private var albumDataSource: [[Post]] = [[]]
    
    private lazy var collectionView: UICollectionView = {
        let layout = AlbumCollectionsLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    init(albumService: AlbumFetcherProtocol) {
        self.albumService = albumService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        Task {
            await configureDataSource()
        }
    }
}

private extension AlbumCollectionsViewController {
    
    func setup() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureDataSource() async {
        var batchedIndexPaths: [IndexPath] = []
        let batchedThreshold: Int = 3

        for await album in await albumService.fetchAlbumCollections() {
            if let album = album {
                albumDataSource.append(album)
                performBatchUpdates(indexPaths: &batchedIndexPaths, threshold: batchedThreshold)
            }
        }
    }
    
    @MainActor
    func performBatchUpdates(indexPaths: inout [IndexPath], threshold: Int) {
        let indexPath = IndexPath(item: albumDataSource.count - 1, section: collectionView.numberOfSections - 1)
        indexPaths.append(indexPath)
        if indexPaths.count >= threshold {
            collectionView.performBatchUpdates {
                collectionView.insertItems(at: indexPaths)
            }
            indexPaths.removeAll()
        }
    }
}

extension AlbumCollectionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albumDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
