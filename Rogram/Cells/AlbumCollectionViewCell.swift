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
        
    private var containerView: ScalableContainerView = {
        let view = ScalableContainerView(frame: .zero, shouldAddHandler: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.backgroundColor = UIColor.colors.randomElement()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(containerColor: UIColor) {
        containerView.backgroundColor = containerColor
    }
}

private extension AlbumCollectionViewCell {
    
    func setup() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
