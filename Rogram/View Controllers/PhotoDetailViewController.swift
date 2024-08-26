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
    
    private lazy var headerView: ConfigurableHeaderView = {
        let view = ConfigurableHeaderView(frame: .zero, showDismissalButton: true, title: "Album Photo Detailed")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.onTap = {
            self.dismiss(animated: true)
        }
        return view
    }()
    
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
        label.font = UIFont(name: "Poppins-Black", size: 22)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

private extension PhotoDetailViewController {
    
    func setup() {
        view.addSubview(headerView)
        view.addSubview(photoImageView)
        view.addSubview(titleLabel)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalToConstant: 350),
            photoImageView.widthAnchor.constraint(equalToConstant: 350),
            
            titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
