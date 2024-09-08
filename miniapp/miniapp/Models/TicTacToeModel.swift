//
//  TicTacToeModel.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 05.09.2024.
//

import Foundation

protocol TicTacToeProtocol: AnyObject {
    func getMatrixValue(col: Int, row: Int) -> TicTacToeModel.MarkSetBy?
    func setMatrixValueByHuman(col: Int, row: Int) -> (TicTacToeModel.StatusOfGame, [(Int, Int)]?)
    func passStepToMachina(completion: @escaping (TicTacToeModel.StatusOfGame, [(Int, Int)]?) -> Void)
    func setIsGameOn(isGameOn: Bool)
    func getIsGameOn() -> Bool
    var modelId: Int { get }
    func getPlayerMarkTaken() -> TicTacToeModel.PlayerMarkTaken?
    
}

class TicTacToeModel: TicTacToeProtocol {
    enum MarkSetBy {
        case human
        case machina
        case none
    }
    enum PlayerMarkTaken {
        case xmarkMark
        case circleMark
    }
    enum StatusOfGame {
        case gameCanBeGoingOn
        case gameIsEndedTheHumanWins
        case gameIsEndedTheMachinaWins
        case gameIsEndedNobodyWins
    }
    var modelId: Int
    private var isGameOn: Bool = false
    private var playerMarkTaken: PlayerMarkTaken?
    private var fieldsMatrix: [[MarkSetBy]] = [[.none, .none, .none], [.none, .none, .none], [.none, .none, .none]]
    init(modelId: Int) {
        self.modelId = modelId
        setRandomPlayerMarkTaken()
    }
    private func setRandomPlayerMarkTaken() {
        playerMarkTaken = Bool.random() ? .xmarkMark : .circleMark
    }
    func getPlayerMarkTaken() -> PlayerMarkTaken? {
        return playerMarkTaken
    }
    func getMatrixValue(col: Int, row: Int) -> MarkSetBy? {
        if col < 0 || col > 2 || row < 0 || row > 2 {
            print("[ERROR]\n[\(#function)][\(#file)]")
            return nil
        } else {
            return fieldsMatrix[col][row]
        }
    }
    func setMatrixValueByHuman(col: Int, row: Int) -> (StatusOfGame, [(Int, Int)]?) {
        if col < 0 || col > 2 || row < 0 || row > 2 {
            print("[ERROR]\n[\(#function)][\(#file)]:\nВыход за границы массива")
        } else {
            print("[DEBUF]: Human делает ход col: \(col + 1), row: \(row + 1)")
            if fieldsMatrix[col][row] == .none {
                fieldsMatrix[col][row] = .human
            } else {
                print("[ERROR]\n[\(#function)][\(#file):\nПопытка установить значение в поле, где значение уже установлено")
            }
        }
        return checkIfGameIsToBeEnded(matrix: self.fieldsMatrix)
    }
    func passStepToMachina(completion: @escaping (StatusOfGame, [(Int, Int)]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let resultAfterHumanStep = self.checkIfGameIsToBeEnded(matrix: self.fieldsMatrix)
            if resultAfterHumanStep.0 == .gameCanBeGoingOn {
                self.machinaLogic()
                let resultAfterMachinaStep = self.checkIfGameIsToBeEnded(matrix: self.fieldsMatrix)
                completion(resultAfterMachinaStep.0, resultAfterMachinaStep.1)
            } else {
                completion(resultAfterHumanStep.0, resultAfterHumanStep.1)
            }
        }
    }
    func setIsGameOn(isGameOn: Bool) {
        self.isGameOn = isGameOn
        if isGameOn {
            for i in 0..<fieldsMatrix.count {
                for j in 0..<fieldsMatrix[i].count {
                    fieldsMatrix[i][j] = .none
                }
            }
            setRandomPlayerMarkTaken()
            if playerMarkTaken == .circleMark {
                machinaLogic()
            }
        }
    }
    func getIsGameOn() -> Bool {
        return isGameOn
    }
    private func machinaLogic() {
        var emptyFields: [(Int, Int)] = []
        for i in 0..<fieldsMatrix.count {
            for j in 0..<fieldsMatrix[i].count {
                if fieldsMatrix[i][j] == .none {
                    emptyFields.append((i, j))
                }
            }
        }
        if emptyFields.count == 9 || emptyFields.count == 8 {
            if let randomPosition = emptyFields.randomElement() {
                print("[DEBUF]: Machina делает случайный ход col: \(randomPosition.0 + 1), row: \(randomPosition.1 + 1)")
                fieldsMatrix[randomPosition.0][randomPosition.1] = .machina
            }
        } else {
            for position in emptyFields {
                var simulatedMatrix = fieldsMatrix.map { $0 }
                simulatedMatrix[position.0][position.1] = .machina
                if checkIfGameIsToBeEnded(matrix: simulatedMatrix).0 == .gameIsEndedTheMachinaWins {
                    print("[DEBUG]: Machina делает победный ход col: \(position.0 + 1), row: \(position.1 + 1)")
                    fieldsMatrix[position.0][position.1] = .machina
                    return
                }
            }
            for position in emptyFields {
                var simulatedMatrix = fieldsMatrix.map { $0 }
                simulatedMatrix[position.0][position.1] = .human
                if checkIfGameIsToBeEnded(matrix: simulatedMatrix).0 == .gameIsEndedTheHumanWins {
                    print("[DEBUG]: Machina блокирует ход человека col: \(position.0 + 1), row: \(position.1 + 1)")
                    fieldsMatrix[position.0][position.1] = .machina
                    return
                }
            }
            if let randomPosition = emptyFields.randomElement() {
                print("[DEBUG]: Machina делает случайный ход col: \(randomPosition.0 + 1), row: \(randomPosition.1 + 1)")
                fieldsMatrix[randomPosition.0][randomPosition.1] = .machina
            }
        }
    }
    private func checkIfGameIsToBeEnded(matrix: [[MarkSetBy]]) -> (StatusOfGame, [(Int, Int)]?) {
        var emptyFields: [(Int, Int)] = []
        var winningPositions: [(Int, Int)]? = nil
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                if matrix[i][j] == .none {
                    emptyFields.append((i, j))
                }
            }
        }
        for i in 0..<matrix.count {
            if matrix[i].allSatisfy({ $0 == .human }) {
                winningPositions = [(i, 0), (i, 1), (i, 2)]
                return (.gameIsEndedTheHumanWins, winningPositions)
            } else if matrix[i].allSatisfy({ $0 == .machina }) {
                winningPositions = [(i, 0), (i, 1), (i, 2)]
                return (.gameIsEndedTheMachinaWins, winningPositions)
            }
        }
        for col in 0..<3 {
            if matrix[0][col] == matrix[1][col], matrix[1][col] == matrix[2][col], matrix[0][col] != .none {
                winningPositions = [(0, col), (1, col), (2, col)]
                return (winnerHelper(markSetBy: matrix[0][col]), winningPositions)
            }
        }
        if matrix[0][0] == matrix[1][1], matrix[1][1] == matrix[2][2], matrix[0][0] != .none {
            winningPositions = [(0, 0), (1, 1), (2, 2)]
            return (winnerHelper(markSetBy: matrix[0][0]), winningPositions)
        }
        if matrix[0][2] == matrix[1][1], matrix[1][1] == matrix[2][0], matrix[0][2] != .none {
            winningPositions = [(0, 2), (1, 1), (2, 0)]
            return (winnerHelper(markSetBy: matrix[0][2]), winningPositions)
        }
        if emptyFields.isEmpty {
            return (.gameIsEndedNobodyWins, nil)
        } else {
            return (.gameCanBeGoingOn, nil)
        }
    }
    private func winnerHelper(markSetBy: MarkSetBy) -> StatusOfGame {
        switch markSetBy {
        case .human:
            return .gameIsEndedTheHumanWins
        case .machina:
            return .gameIsEndedTheMachinaWins
        case .none:
            print("[ERROR]\n[\(#function)][\(#file):\nmarkSetBy = \(markSetBy)")
            return .gameCanBeGoingOn
        }
    }
}
