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
    private let postService: PostFetcherProtocol
    private lazy var transitionDelegate = PhotoTransitionDelegate()

    private var albumDataSource: [[Post]] = []
    private let itemSize: CGSize = CGSize(width: 160, height: 250)
    
    private var headerView: ConfigurableHeaderView = {
        let view = ConfigurableHeaderView(frame: .zero, title: "Album Collections")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = AlbumCollectionsLayout(itemSize: itemSize, totalWidth: UIScreen.main.bounds.width)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(albumService: AlbumFetcherProtocol, postService: PostFetcherProtocol) {
        self.albumService = albumService
        self.postService = postService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await configureDataSource()
        }
    }
}

private extension AlbumCollectionsViewController {
    
    func setup() {
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
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
    
    func colorForIndexPath(_ item: Int) -> UIColor {
        if item < UIColor.colors.count {
            return UIColor.colors[item]
        } else {
            return UIColor.colors[item % UIColor.colors.count]
        }
    }
}

extension AlbumCollectionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albumDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(containerColor: colorForIndexPath(indexPath.item))
        return cell
    }
}

extension AlbumCollectionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell,
            let cellFrame = cell.superview?.convert(cell.frame, to: nil)
        else { return }
        
        let albumViewController = AlbumViewController(
            postService: postService,
            posts: albumDataSource[indexPath.row]
        )
        
        transitionDelegate.startingFrame = cellFrame
        albumViewController.transitioningDelegate = transitionDelegate
        albumViewController.modalPresentationStyle = .custom
        present(albumViewController, animated: true)
    }
}
