//
//  AlbumsViewController.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let postService: PostFetcherProtocol
    
    private lazy var collectionView: UICollectionView = {
        let layout = FeaturedPostsLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FeaturedPostsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPostsCollectionViewCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    init(postService: PostFetcherProtocol) {
        self.postService = postService
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
            let results = await postService.fetchPostObjects()
            await postService.streamAggregatedPosts(posts: results)
        }
    }
}

private extension AlbumsViewController {
    
    func setup() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension AlbumsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPostsCollectionViewCell.identifier, for: indexPath) as? FeaturedPostsCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
