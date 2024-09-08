//
//  ViewController.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 03.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var collection: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private var navBarView = NavBarView()
    private var modelsTicTacToe: [TicTacToeModel] = [
        TicTacToeModel(modelId: 0),
        TicTacToeModel(modelId: 1),
        TicTacToeModel(modelId: 2),
        TicTacToeModel(modelId: 3),
        TicTacToeModel(modelId: 4),
        TicTacToeModel(modelId: 5),
        TicTacToeModel(modelId: 6),
        TicTacToeModel(modelId: 7),
        TicTacToeModel(modelId: 8),
        TicTacToeModel(modelId: 9)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(navBarView)
        navBarView.setup(delegate: self)
        navBarView.setState(state: AppModel.shared.state)
        view.addSubview(collection)
        collection.register(TicTacToeCollectionViewCell.self, forCellWithReuseIdentifier: TicTacToeCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .gray
        setupConstraints()
    }
    func refreshCollection() {
        collection.reloadData()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collection.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}
extension ViewController: NavBarViewDelegate & PlaygroundDelegate {
    func navBarLeftButtonTapped() {
        AppModel.shared.state = .oneToTwo
        navBarView.setState(state: .oneToTwo)
    }
    func toFullSizeTapped(miniApp: MiniApp, index: Int) {
        print(#function)
        AppModel.shared.state = .fullScreen
        switch miniApp {
        case .appTicTacToe:
            let viewController = TicTacToeViewController()
            let model = modelsTicTacToe.first(where: { $0.modelId == index })
            viewController.vc = self
            viewController.model = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func navBarRightButtonTapped(isTapAccomplished: Bool) {
        if isTapAccomplished {
            switch AppModel.shared.state {
            case .oneToEight:
                AppModel.shared.state = .oneToTwo
            case .oneToTwo:
                AppModel.shared.state = .oneToEight
            case .fullScreen:
                print("[ERROR]\n[\(#function)][\(#file)]")
            }
            collection.reloadData()
        } else {
            switch AppModel.shared.state {
            case .oneToEight:
                navBarView.setState(state: .oneToTwo)
            case .oneToTwo:
                navBarView.setState(state: .oneToEight)
            case .fullScreen:
                print("[ERROR]\n[\(#function)][\(#file)]")
            }
        }
    }
}
extension ViewController {
    private func setupConstraints() {
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        collection.translatesAutoresizingMaskIntoConstraints = false

        navBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelsTicTacToe.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicTacToeCollectionViewCell.identifier, for: indexPath as IndexPath) as? TicTacToeCollectionViewCell {
            cell.setup(delegate: self, model: modelsTicTacToe[indexPath.row])
            return cell
        } else {
            print("[ERROR]\n[\(#function)][\(#file)]:\nCannot do cast to TicTacToeCollectionViewCell")
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[DEBUG]: pressed cell \(indexPath.item)")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isPortrait = collectionView.bounds.width < collectionView.bounds.height
        switch AppModel.shared.state {
        case .oneToEight:
            let cellHeight: CGFloat = isPortrait ? collectionView.bounds.height / 8 : collectionView.bounds.height / 2
            let cellWidth: CGFloat = isPortrait ? collectionView.bounds.width : collectionView.bounds.width / 2
            return CGSize(width: cellWidth - 2, height: cellHeight)
        case .oneToTwo:
            let cellHeight: CGFloat = isPortrait ? collectionView.bounds.height / 2 : collectionView.bounds.width / 2
            let cellWidth: CGFloat = isPortrait ? collectionView.bounds.width : collectionView.bounds.width / 2
            return CGSize(width: cellWidth - 2, height: cellHeight)
        case .fullScreen:
            let cellHeight: CGFloat = isPortrait ? collectionView.bounds.height / 2 : collectionView.bounds.width / 2
            let cellWidth: CGFloat = isPortrait ? collectionView.bounds.width : collectionView.bounds.width / 2
            return CGSize(width: cellWidth - 2, height: cellHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
