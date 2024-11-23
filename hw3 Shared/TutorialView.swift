//
//  TutorialView.swift
//  hw3 iOS
//
//  Created by James.Lai on 23/11/2024.
//

import SwiftUI

@Observable class ObservableViewModel {
    var title: String = "role1"
}

struct TutorialView: View {
    @State private var isSheetPresented = false // 控制 sheet 的顯示狀態
    private var viewModel = ObservableViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 按钮切换文字
            Button(viewModel.title) {
                viewModel.title = "遊戲共分為四個等級，等級越高敵人生成速度越快。玩家共有三條命，當有敵人跑出下方螢幕，玩家就會扣一條命，扣完就結束遊戲。"
            }

            // 第二个按钮切换文字
            Button("role2") {
                viewModel.title = "玩家要避免被敵人撞到，被敵人撞到會爆炸並結束遊戲。"
            }

            // 第三个按钮切换文字
            Button("role3") {
                viewModel.title = "玩家可以發射子彈去射敵人，射到一個敵人分數加一分。在結束遊戲後玩家可以看到目前遊玩過的最高分數。點擊Restart可重新開始遊戲"
            }

            // 点击 Detail 显示更多信息
            Text("Detail")
                .foregroundColor(.blue)
                .underline()
                .onTapGesture {
                    isSheetPresented = true // 顯示 sheet
                }
        }
        .frame(width: 300)
        .sheet(isPresented: $isSheetPresented) {
            DetailView()
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("等級1:敵人生成速度3秒一次")
                .foregroundColor(Color.blue)
            Text("等級2:敵人生成速度2秒一次")
                .foregroundColor(Color.blue)
            Text("等級3:敵人生成速度1秒一次")
                .foregroundColor(Color.blue)
            Text("   等級4:敵人生成速度0.5秒一次")
                .foregroundColor(Color.blue)
        }
    }
}

#Preview {
    TutorialView()
}
