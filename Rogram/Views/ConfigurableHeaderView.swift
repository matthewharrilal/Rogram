//
//  ConfigurableHeaderView.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import UIKit

class ConfigurableHeaderView: UIView {
    
    private let showDismissalButton: Bool
    private let title: String
    
    public var onTap: (() -> Void)?
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-ExtraBold", size: 22)
        return label
    }()
    
    private lazy var dismissalButton: ScalableContainerView = {
        let view = ScalableContainerView(frame: .zero, shouldAddHandler: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .red
        view.onTap = { [weak self] in
            self?.onTap?()
        }
        return view
    }()

    init(
        frame: CGRect,
        showDismissalButton: Bool = false,
        title: String
    ) {
        self.showDismissalButton = showDismissalButton
        self.title = title
        super.init(frame: frame)
        
        setup()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConfigurableHeaderView {
    
    func setup() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 75),
        ])
        
        if showDismissalButton {
            layoutDismissalButton()
        }
    }
    
    func configure() {
        titleLabel.text = title
    }
    
    func layoutDismissalButton() {
        containerView.addSubview(dismissalButton)
        
        NSLayoutConstraint.activate([
            dismissalButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            dismissalButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dismissalButton.heightAnchor.constraint(equalToConstant: 32),
            dismissalButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
}
