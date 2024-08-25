//
//  AlbumsViewController.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let postService: PostFetcherProtocol
    
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
        
        Task {
            await postService.fetchPostObjects()
        }
    }
}

