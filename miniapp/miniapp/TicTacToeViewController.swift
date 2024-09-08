//
//  TicTacToeViewController.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 06.09.2024.
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    private var navBarView = NavBarView()
    var model: TicTacToeModel?
    weak var vc: ViewController?
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(navBarView)
        view.addSubview(playgroundView)
        navBarView.setup(delegate: self)
        navBarView.setState(state: .fullScreen)
        setupPlayground()
        setupConstraints()
    }
    private func setupPlayground() {
        guard let model = model else { return }
        playgroundView.setup(delegate: self, model: model)
    }
}
extension TicTacToeViewController: NavBarViewDelegate & PlaygroundDelegate {
    func navBarLeftButtonTapped() {
        guard let vc = vc else { return }
        vc.refreshCollection()
        AppModel.shared.state = .oneToTwo
        navBarView.setState(state: .oneToTwo)
        navigationController?.popViewController(animated: true)
    }
    func toFullSizeTapped(miniApp: MiniApp, index: Int) {
        print("[ERROR]\n[\(#function)][\(#file)]")
    }
    func navBarRightButtonTapped(isTapAccomplished: Bool) {
        print("[ERROR]\n[\(#function)][\(#file)]")
    }
}
extension TicTacToeViewController {
    private func setupConstraints() {
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        playgroundView.translatesAutoresizingMaskIntoConstraints = false

        navBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        playgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        playgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        playgroundView.topAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        playgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
