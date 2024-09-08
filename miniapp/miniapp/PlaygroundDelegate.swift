//
//  PlaygroundDelegate.swift
//  miniapp
//
//  Created by  Alexander Fedoseev on 05.09.2024.
//

import Foundation

protocol PlaygroundDelegate: AnyObject {
    func toFullSizeTapped(miniApp: MiniApp, index: Int)
}
