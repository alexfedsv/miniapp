//
//  TicTacToeCollectionViewCell.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 03.09.2024.
//

import UIKit

class TicTacToeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TicTacToeCollectionViewCell"
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "КpЕСТИКИ!\nИ!\nНОЛиКИ!"
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private lazy var xmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        imageView.tintColor = .white
        return imageView
    }()
    private lazy var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .white
        return imageView
    }()
    private var playgroundView: TicTacToeView = {
        let view = TicTacToeView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(xmarkImageView)
        addSubview(circleImageView)
        addSubview(playgroundView)
        backgroundColor = .black
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func prepareForReuse() {
        playgroundView.reset()
    }
    func setup(delegate: PlaygroundDelegate, model: TicTacToeModel) {
        self.playgroundView.setup(delegate: delegate, model: model)
        if AppModel.shared.state == .oneToEight {
            playgroundView.isUserInteractionEnabled = false
        } else {
            playgroundView.isUserInteractionEnabled = true
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if AppModel.shared.state == .oneToEight {
            titleLabel.isHidden = false
            xmarkImageView.isHidden = false
            circleImageView.isHidden = false
        } else {
            titleLabel.isHidden = true
            xmarkImageView.isHidden = true
            circleImageView.isHidden = true
        }
    }
}
extension TicTacToeCollectionViewCell {
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        playgroundView.translatesAutoresizingMaskIntoConstraints = false
        xmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        
        playgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -5).isActive = true
        playgroundView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -5).isActive = true
        
        xmarkImageView.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -65).isActive = true
        xmarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        xmarkImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        xmarkImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        circleImageView.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -90).isActive = true
        circleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: +10).isActive = true
        circleImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        circleImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
