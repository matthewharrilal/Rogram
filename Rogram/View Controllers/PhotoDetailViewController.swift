//
//  PhotoDetailViewController.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: TODO -> Refactor ... not the biggest fan of this approach
    public var post: AggregatedPost? {
        didSet {
            guard let post = post else { return }
            photoImageView.image = post.image
            titleLabel.text = post.title
        }
    }
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setup()
    }
}

private extension PhotoDetailViewController {
    
    func setup() {
        view.addSubview(photoImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalToConstant: 250),
            photoImageView.widthAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
