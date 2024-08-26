//
//  AlbumsViewController.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let postService: PostFetcherProtocol
    private let posts: [Post]
    
    private var postsDataSource: [AggregatedPost] = []
    private lazy var photoTransitionDelegate = PhotoTransitionDelegate()
    private lazy var photoDetailViewController = PhotoDetailViewController()
    
    private lazy var headerView: ConfigurableHeaderView = {
        let view = ConfigurableHeaderView(frame: .zero, showDismissalButton: true, title: "Featured Album Photos")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.onTap = {
            self.dismiss(animated: true)
        }
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = FeaturedPostsLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FeaturedPostsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPostsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(postService: PostFetcherProtocol, posts: [Post]) {
        self.postService = postService
        self.posts = posts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        
        Task {
            await configureDataSource()
        }
    }
}

private extension AlbumViewController {
    
    func setup() {
        view.addSubview(collectionView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureDataSource() async {
        let batchedThreshold: Int = 4
        
        if let stream = await postService.streamAggregatedPosts(posts: posts) {
            var batchedIndexPaths: [IndexPath] = []
            
            for await post in stream {
                postsDataSource.append(post)
                performBatchUpdates(indexPaths: &batchedIndexPaths, threshold: batchedThreshold)
            }
        }
    }
    
    @MainActor
    func performBatchUpdates(indexPaths: inout [IndexPath], threshold: Int) {
        let indexPath = IndexPath(item: postsDataSource.count - 1, section: collectionView.numberOfSections - 1)
        indexPaths.append(indexPath)
        if indexPaths.count >= threshold {
            collectionView.performBatchUpdates {
                collectionView.insertItems(at: indexPaths)
            }
            indexPaths.removeAll()
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPostsCollectionViewCell.identifier, for: indexPath) as? FeaturedPostsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(post: postsDataSource[indexPath.row])
        return cell
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    
    // MARK: TODO -> Fix presentation logic and make nicer
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FeaturedPostsCollectionViewCell else { return }
        
        photoDetailViewController.post = postsDataSource[indexPath.row]
        if let cellFrame = cell.superview?.convert(cell.frame, to: nil) {
            photoTransitionDelegate.startingFrame = cellFrame
            photoDetailViewController.transitioningDelegate = photoTransitionDelegate
            photoDetailViewController.modalPresentationStyle = .custom
            present(photoDetailViewController, animated: true)
        }
    }
}
