//
//  Untitled.swift
//  hw3 iOS
//
//  Created by James.Lai on 22/11/2024.
//

import SwiftUI
import UIKit

struct GameViewControllerWrapper: UIViewControllerRepresentable {
    // 創建並返回 GameViewController
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }

    // 如果需要，更新 GameViewController 的狀態
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // 此處目前不需要實現任何邏輯
    }
}
