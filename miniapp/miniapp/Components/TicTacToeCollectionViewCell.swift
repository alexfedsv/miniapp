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
        label.text = "-label-"
        return label
    }()
    private var playgroundView: UIView = {
        let view = UIView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        //let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addSubview(titleLabel)
        backgroundColor = .red
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup() {
    }
    @objc
    func cellTapped() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension TicTacToeCollectionViewCell {
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
    }
}
