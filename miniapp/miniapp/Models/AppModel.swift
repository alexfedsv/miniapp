//
//  AppModel.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 05.09.2024.
//

import Foundation

struct AppModel {
    static var shared = AppModel()
    private init() {}
    var state: AppearanceState = .oneToEight
}
