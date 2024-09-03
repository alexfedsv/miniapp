//
//  NavBarView.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 04.09.2024.
//

import UIKit

protocol NavBarViewDelegate: AnyObject {
    func navBarRightButtonTapped()
}

class NavBarView: UIView {

    private weak var delegate: NavBarViewDelegate?
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .systemPink
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(rightImageView)
        rightImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightButtonTapped)))
        backgroundColor = .systemGray
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(delegate: NavBarViewDelegate) {
        self.delegate = delegate
    }
    @objc
    private func rightButtonTapped() {
        guard let delegate = delegate else { return }
        UIView.animate(withDuration: 0.5) {
            self.rightImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.rightImageView.layer.opacity = 0.9
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.rightImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.rightImageView.layer.opacity = 1.0
            } completion: { _ in
                delegate.navBarRightButtonTapped()
            }
        }
    }
}
extension NavBarView {
    private func setupConstraints() {
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        rightImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        rightImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        rightImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
    }
}
