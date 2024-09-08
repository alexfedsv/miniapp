//
//  NavBarView.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 04.09.2024.
//

import UIKit

protocol NavBarViewDelegate: AnyObject {
    func navBarRightButtonTapped(isTapAccomplished: Bool)
    func navBarLeftButtonTapped()
}

class NavBarView: UIView {

    private weak var delegate: NavBarViewDelegate?
    private var isImageViewsBlocked: Bool = false
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "chevron.backward")
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftImageView)
        addSubview(rightImageView)
        leftImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftButtonTapped)))
        rightImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightButtonTapped)))
        backgroundColor = .darkGray
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(delegate: NavBarViewDelegate) {
        self.delegate = delegate
    }
    func setState(state: AppearanceState) {
        DispatchQueue.main.async {
            switch state {
            case .oneToEight:
                self.rightImageView.image = UIImage(systemName: "plus.circle")
                self.rightImageView.isHidden = false
                self.leftImageView.isHidden = true
            case .oneToTwo:
                self.rightImageView.image = UIImage(systemName: "minus.circle")
                self.rightImageView.isHidden = false
                self.leftImageView.isHidden = true
            case .fullScreen:
                self.rightImageView.image = UIImage(systemName: "minus.circle")
                self.rightImageView.isHidden = true
                self.leftImageView.isHidden = false
            }
        }
    }
    @objc
    private func rightButtonTapped() {
        if !isImageViewsBlocked {
            isImageViewsBlocked = true
            guard let delegate = delegate else { return }
            UIView.animate(withDuration: 0.5) {
                self.rightImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.rightImageView.layer.opacity = 0.8
            } completion: { _ in
                delegate.navBarRightButtonTapped(isTapAccomplished: false)
                UIView.animate(withDuration: 0.5) {
                    self.rightImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.rightImageView.layer.opacity = 1.0
                } completion: { _ in
                    delegate.navBarRightButtonTapped(isTapAccomplished: true)
                    self.isImageViewsBlocked = false
                }
            }
        }
    }
    @objc
    private func leftButtonTapped() {
        if !isImageViewsBlocked {
            isImageViewsBlocked = true
            guard let delegate = delegate else { return }
            UIView.animate(withDuration: 0.5) {
                self.leftImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.leftImageView.layer.opacity = 0.8
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.leftImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.leftImageView.layer.opacity = 1.0
                } completion: { _ in
                    delegate.navBarLeftButtonTapped()
                    self.isImageViewsBlocked = false
                }
            }
        }
    }
}
extension NavBarView {
    private func setupConstraints() {
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        
        rightImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        rightImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        rightImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        
        leftImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        leftImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        leftImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        leftImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -14).isActive = true
    }
}
