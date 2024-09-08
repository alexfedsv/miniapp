//
//  TicTacToeView.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 05.09.2024.
//

import UIKit

class TicTacToeView: UIView {

    private weak var delegate: PlaygroundDelegate?
    private var isButtonBlocked: Bool = false
    private var isFullScreenImageViewBlocked: Bool = false
    private weak var model: TicTacToeProtocol?
    private var matrix: [[UIImageView]] = [
        [UIImageView(), UIImageView(), UIImageView()],
        [UIImageView(), UIImageView(), UIImageView()],
        [UIImageView(), UIImageView(), UIImageView()]
    ]
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = ""
        label.layer.opacity = 0.0
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    private lazy var fullScreenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    private lazy var humanLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Человек:"
        return label
    }()
    private lazy var machinaLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "Машина:"
        return label
    }()
    private lazy var humanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .black
        return imageView
    }()
    private lazy var machinaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .black
        return imageView
    }()
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    private lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Начать игру"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        matrix.forEach({ $0.forEach( {
            addSubview($0)
            $0.backgroundColor = .black
            $0.tintColor = .white
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
            $0.isUserInteractionEnabled = false
        })})
        addSubview(buttonView)
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleButtonTap)))
        buttonView.addSubview(buttonLabel)
        addSubview(fullScreenImageView)
        fullScreenImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fullScreenButtonTapped)))
        addSubview(humanLabel)
        addSubview(machinaLabel)
        addSubview(humanImageView)
        addSubview(machinaImageView)
        addSubview(resultLabel)
        backgroundColor = .systemGray
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(delegate: PlaygroundDelegate, model: TicTacToeModel) {
        self.delegate = delegate
        self.model = model
        reset()
    }
    func reset() {
        guard let model = model else { return }
        if model.getIsGameOn() {
            refreshPlaygroundFields()
            setPlayersChosenMarks()
            buttonLabel.text = "Закончить игру"
            unblockPlaygroundFields()
        } else {
            refreshPlaygroundFields()
            setPlayersChosenMarks()
            buttonLabel.text = "Начать игру"
            blockPlaygroundFields()
        }
    }
    private func refreshPlaygroundFields() {
        guard let model = model else { return }
        let isGameOn = model.getIsGameOn()
        for (row, imageViews) in matrix.enumerated() {
            for (col, _) in imageViews.enumerated() {
                DispatchQueue.main.async {
                    if isGameOn {
                        if let fieldMatrixValue = model.getMatrixValue(col: row, row: col), let playerMarkTaken = model.getPlayerMarkTaken() {
                            self.matrix[row][col].image = self.refreshPlaygroundFieldsHelper(fieldMatrixValue: fieldMatrixValue, playerMarkTaken: playerMarkTaken)
                        }
                    } else {
                        self.matrix[row][col].image = nil
                    }
                }
            }
        }
    }
    private func refreshPlaygroundFieldsHelper(
        fieldMatrixValue: TicTacToeModel.MarkSetBy,
        playerMarkTaken: TicTacToeModel.PlayerMarkTaken) -> UIImage? {
            switch fieldMatrixValue {
            case .human:
                switch playerMarkTaken {
                case .xmarkMark:
                    return UIImage(systemName: "xmark")
                case .circleMark:
                    return UIImage(systemName: "circle")
                }
            case .machina:
                switch playerMarkTaken {
                case .xmarkMark:
                    return UIImage(systemName: "circle")
                case .circleMark:
                    return UIImage(systemName: "xmark")
                }
            case .none:
                return nil
            }
    }
    private func setPlayersChosenMarks() {
        if let model = model {
            DispatchQueue.main.async {
                if model.getIsGameOn() {
                    if let playerMarkTaken = model.getPlayerMarkTaken() {
                        switch playerMarkTaken {
                        case .xmarkMark:
                            self.humanImageView.image = UIImage(systemName: "xmark")
                            self.machinaImageView.image = UIImage(systemName: "circle")
                        case .circleMark:
                            self.humanImageView.image = UIImage(systemName: "circle")
                            self.machinaImageView.image = UIImage(systemName: "xmark")
                        }
                    } else {
                        self.humanImageView.image = UIImage(systemName: "questionmark")
                        self.machinaImageView.image = UIImage(systemName: "questionmark")
                    }
                } else {
                    self.humanImageView.image = UIImage(systemName: "questionmark")
                    self.machinaImageView.image = UIImage(systemName: "questionmark")
                }
            }
        }
    }
    private func gameBegins() {
        matrix.forEach({$0.forEach({$0.tintColor = .white })})
        resultLabel.isHidden = true
        resultLabel.text = ""
        resultLabel.layer.opacity = 0.0
        unblockPlaygroundFields()
        refreshPlaygroundFields()
        setPlayersChosenMarks()
    }
    private func gameEnded(status: TicTacToeModel.StatusOfGame, winningPositions: [(Int, Int)]?) {
        blockPlaygroundFields()
        resultLabel.isHidden = false
        switch status {
        case .gameCanBeGoingOn:
            self.resultLabel.text = "ТЫ СДАЛСЯ!"
            self.resultLabel.font = .systemFont(ofSize: 40, weight: .bold)
        case .gameIsEndedTheHumanWins:
            self.resultLabel.text = "ПОБЕДА!"
            self.resultLabel.font = .systemFont(ofSize: 50, weight: .bold)
            if let winningPositions = winningPositions {
                for position in winningPositions {
                    let (row, col) = position
                    let imageView = matrix[row][col]
                    imageView.tintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
                }
            }
        case .gameIsEndedTheMachinaWins:
            self.resultLabel.text = "ПОРАЖЕНИЕ!"
            self.resultLabel.font = .systemFont(ofSize: 40, weight: .bold)
            if let winningPositions = winningPositions {
                for position in winningPositions {
                    let (row, col) = position
                    let imageView = matrix[row][col]
                    imageView.tintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
                }
            }
        case .gameIsEndedNobodyWins:
            self.resultLabel.text = "НИЧЬЯ!"
            self.resultLabel.font = .systemFont(ofSize: 55, weight: .bold)
        }
        UIView.animate(withDuration: 1.5) {
            self.resultLabel.layer.opacity = 1.0
        }
    }
    private func blockPlaygroundFields() {
        matrix.forEach({ $0.forEach( {
            $0.isUserInteractionEnabled = false
        })})
    }
    private func unblockPlaygroundFields() {
        matrix.forEach({ $0.forEach( {
            $0.isUserInteractionEnabled = true
        })})
    }
    private func passToMachina() {
        guard let model = model else { return }
        model.passStepToMachina { status, winningPositions in
            if status == .gameCanBeGoingOn {
                self.refreshPlaygroundFields()
                self.unblockPlaygroundFields()
            } else {
                self.refreshPlaygroundFields()
                self.buttonLabel.text = "Начать игру"
                model.setIsGameOn(isGameOn: false)
                self.gameEnded(status: status, winningPositions: winningPositions)
            }
        }
    }
    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedImageView = gesture.view as? UIImageView else { return }
        guard let model = model else { return }
        self.blockPlaygroundFields()
        for (col, imageViews) in matrix.enumerated() {
            if let row = imageViews.firstIndex(of: tappedImageView) {
                if let field = model.getMatrixValue(col: col, row: row) {
                    if field == .none {
                        let result = model.setMatrixValueByHuman(col: col, row: row)
                        self.refreshPlaygroundFields()
                        if result.0 == .gameCanBeGoingOn {
                            self.passToMachina()
                        } else {
                            self.buttonLabel.text = "Начать игру"
                            model.setIsGameOn(isGameOn: false)
                            self.gameEnded(status: result.0, winningPositions: result.1)
                        }
                    }
                }
                break
            }
        }
    }
    @objc 
    private func handleButtonTap() {
        guard let model = model else { return }
        let isGameOn = model.getIsGameOn()
        if !isButtonBlocked {
            isButtonBlocked = true
            UIView.animate(withDuration: 0.5) {
                self.buttonView.layer.opacity = 0.8
                self.layoutSubviews()
            } completion: { _ in
                if !isGameOn {
                    self.buttonLabel.text = "Закончить игру"
                } else {
                    self.buttonLabel.text = "Начать игру"
                }
                UIView.animate(withDuration: 0.5) {
                    self.buttonView.layer.opacity = 1.0
                    self.layoutSubviews()
                } completion: { _ in
                    model.setIsGameOn(isGameOn: !isGameOn)
                    !isGameOn ? self.gameBegins() : self.gameEnded(status: .gameCanBeGoingOn, winningPositions: nil)
                    self.isButtonBlocked = false
                }
            }
        }
    }
    @objc
    private func fullScreenButtonTapped() {
        guard let delegate = delegate else { return }
        guard let model = model else { return }
        if !isFullScreenImageViewBlocked {
            isFullScreenImageViewBlocked = true
            UIView.animate(withDuration: 0.5) {
                self.fullScreenImageView.layer.opacity = 0.5
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.fullScreenImageView.layer.opacity = 1.0
                } completion: { _ in
                    delegate.toFullSizeTapped(miniApp: .appTicTacToe, index: model.modelId)
                    self.isFullScreenImageViewBlocked = false
                }
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        switch AppModel.shared.state {
        case .oneToEight:
            let minus: CGFloat = 0
            let space: CGFloat = 1.0
            let side: CGFloat = ((self.bounds.width - space * 4) / 3) - minus
            for (row, imageViews) in matrix.enumerated() {
                for (col, imageView) in imageViews.enumerated() {
                    imageView.frame = .init(x: space * CGFloat(row + 1) + side * CGFloat(row),
                                            y: space * CGFloat(col + 1) + side * CGFloat(col),
                                            width: side,
                                            height: side)
                }
            }
            resultLabel.isHidden = true
            humanLabel.isHidden = true
            machinaLabel.isHidden = true
            humanImageView.isHidden = true
            machinaImageView.isHidden = true
            buttonView.isHidden = true
            buttonLabel.isHidden = true
            fullScreenImageView.isHidden = true
            buttonView.frame = .init(x: 0,
                                     y: 0,
                                     width: 0,
                                     height: 0)
            buttonLabel.frame = buttonView.bounds
            buttonView.layer.cornerRadius = 0
            fullScreenImageView.frame = .init(x: 0,
                                              y: 0,
                                              width: 0,
                                              height: 0)
            humanLabel.frame = .init(x: 0,
                                     y: 0,
                                     width: 0,
                                     height: 0)
            machinaLabel.frame = .init(x: 0,
                                       y: 0,
                                       width: 0,
                                       height: 0)
            humanImageView.frame = .init(x: 0,
                                     y: 0,
                                     width: 0,
                                     height: 0)
            machinaImageView.frame = .init(x: 0,
                                       y: 0,
                                       width: 0,
                                       height: 0)
            resultLabel.frame = .init(x: 0,
                                      y: 0,
                                      width: 0,
                                      height: 0)
        case .oneToTwo:
            let minus: CGFloat = 20.0
            let space: CGFloat = 2.0
            let side: CGFloat = ((self.bounds.width - space * 4) / 3) - minus
            for (row, imageViews) in matrix.enumerated() {
                for (col, imageView) in imageViews.enumerated() {
                    imageView.frame = .init(x: space * CGFloat(row + 1) + side * CGFloat(row),
                                            y: space * CGFloat(col + 1) + side * CGFloat(col),
                                            width: side,
                                            height: side)
                }
            }
            humanLabel.isHidden = false
            machinaLabel.isHidden = false
            humanImageView.isHidden = false
            machinaImageView.isHidden = false
            buttonView.isHidden = false
            buttonLabel.isHidden = false
            fullScreenImageView.isHidden = false
            buttonView.layer.cornerRadius = 8
            buttonView.frame = .init(x: 15,
                                     y: side * 3 + space * 4 + 5,
                                     width: 150,
                                     height: bounds.height - side * 3 - space * 4 - 5 - 5)
            buttonLabel.frame = buttonView.bounds
            fullScreenImageView.frame = .init(x: side * 3 + space * 4 + 5,
                                              y: ((side + space) / 2) - ((bounds.height - side * 3 - space * 4 - 5 - 5) / 2),
                                              width: bounds.height - side * 3 - space * 4 - 5 - 5,
                                              height: bounds.height - side * 3 - space * 4 - 5 - 5)
            humanLabel.frame = .init(x: buttonView.frame.maxX + 15,
                                     y: buttonView.frame.minY + 3,
                                     width: 80,
                                     height: buttonView.bounds.height / 3)
            machinaLabel.frame = .init(x: buttonView.frame.maxX + 15,
                                       y: buttonView.frame.maxY - buttonView.bounds.height / 3 - 3,
                                       width: 80,
                                       height: buttonView.bounds.height / 3)
            humanImageView.frame = .init(x: humanLabel.frame.maxX + 5,
                                         y: buttonView.frame.minY + 3,
                                         width: buttonView.bounds.height / 3,
                                         height: buttonView.bounds.height / 3)
            machinaImageView.frame = .init(x: machinaLabel.frame.maxX + 5,
                                       y: buttonView.frame.maxY - buttonView.bounds.height / 3 - 3,
                                       width: buttonView.bounds.height / 3,
                                       height: buttonView.bounds.height / 3)
            resultLabel.frame = .init(x: self.bounds.minX,
                                      y: ((side * 3 + space * 4) / 2) - 25,
                                      width: (side * 3 + space * 4),
                                      height: 50)
            
        case .fullScreen:
            let orientation = UIDevice.current.orientation
            switch orientation {
            case .portrait, .portraitUpsideDown:
                print("Портретный режим")
                let minus: CGFloat = 0.0
                let space: CGFloat = 4.0
                let side: CGFloat = ((self.bounds.width - space * 4) / 3) - minus
                for (row, imageViews) in matrix.enumerated() {
                    for (col, imageView) in imageViews.enumerated() {
                        imageView.frame = .init(x: space * CGFloat(row + 1) + side * CGFloat(row),
                                                y: space * CGFloat(col + 1) + side * CGFloat(col),
                                                width: side,
                                                height: side)
                    }
                }
                humanLabel.isHidden = false
                machinaLabel.isHidden = false
                humanImageView.isHidden = false
                machinaImageView.isHidden = false
                buttonView.isHidden = false
                buttonLabel.isHidden = false
                fullScreenImageView.isHidden = false
                buttonView.layer.cornerRadius = 12
                buttonView.frame = .init(x: 15,
                                         y: side * 3 + space * 4 + 10,
                                         width: side * 3 + space * 4 - 30,
                                         height: 60)
                buttonLabel.frame = buttonView.bounds
                fullScreenImageView.frame = .init(x: 0,
                                                  y: 0,
                                                  width: 0,
                                                  height: 0)
                humanLabel.frame = .init(x: buttonView.frame.minX + 10,
                                         y: buttonView.frame.maxY + 30,
                                         width: 80,
                                         height: 40)
                machinaLabel.frame = .init(x: buttonView.frame.minX + 10,
                                           y: buttonView.frame.maxY + 80 + 40,
                                           width: 80,
                                           height: 40)
                humanImageView.frame = .init(x: humanLabel.frame.maxX + 10,
                                         y: buttonView.frame.maxY + 30,
                                         width: 40,
                                         height: 40)
                machinaImageView.frame = .init(x: machinaLabel.frame.maxX + 10,
                                           y: buttonView.frame.maxY + 80 + 40,
                                           width: 40,
                                           height: 40)
                resultLabel.frame = .init(x: self.bounds.minX,
                                          y: ((side * 3 + space * 4) / 2) - 45,
                                          width: (side * 3 + space * 4),
                                          height: 60)
            case .landscapeLeft, .landscapeRight:
                print("Ландшафтный режим")
                let space: CGFloat = 4.0
                let side: CGFloat = ((self.bounds.height - space * 4) / 3)
                for (row, imageViews) in matrix.enumerated() {
                    for (col, imageView) in imageViews.enumerated() {
                        imageView.frame = .init(x: space * CGFloat(row + 1) + side * CGFloat(row),
                                                y: space * CGFloat(col + 1) + side * CGFloat(col),
                                                width: side,
                                                height: side)
                    }
                }
                humanLabel.isHidden = false
                machinaLabel.isHidden = false
                humanImageView.isHidden = false
                machinaImageView.isHidden = false
                buttonView.isHidden = false
                buttonLabel.isHidden = false
                fullScreenImageView.isHidden = false
                buttonView.layer.cornerRadius = 12
                buttonView.frame = .init(x: side * 3 + space * 4 + 30,
                                         y: 70,
                                         width: bounds.width - (side * 3 + space * 4 + 60),
                                         height: 60)
                buttonLabel.frame = buttonView.bounds
                fullScreenImageView.frame = .init(x: 0,
                                                  y: 0,
                                                  width: 0,
                                                  height: 0)
                humanLabel.frame = .init(x: buttonView.frame.minX + 20,
                                         y: buttonView.frame.maxY + 50,
                                         width: 80,
                                         height: 40)
                machinaLabel.frame = .init(x: buttonView.frame.minX + 20,
                                           y: buttonView.frame.maxY + 80 + 50,
                                           width: 80,
                                           height: 40)
                humanImageView.frame = .init(x: humanLabel.frame.maxX + 10,
                                         y: buttonView.frame.maxY + 50,
                                         width: 40,
                                         height: 40)
                machinaImageView.frame = .init(x: machinaLabel.frame.maxX + 10,
                                               y: buttonView.frame.maxY + 80 + 50,
                                               width: 40,
                                               height: 40)
                resultLabel.frame = .init(x: self.bounds.minX,
                                          y: ((side * 3 + space * 4) / 2) - 45,
                                          width: (side * 3 + space * 4),
                                          height: 60)
            default:
                print("Неизвестный режим")
                break
            }
        }
    }
}
