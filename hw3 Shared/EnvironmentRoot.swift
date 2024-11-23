//
//  EnvironmentRoot.swift
//  hw3 iOS
//
//  Created by James.Lai on 21/11/2024.
//

import SwiftUI
@main

struct EnvironmentRoot: App{
    @StateObject var viewModel = ContentViewModel()
    
    var body: some Scene{
        WindowGroup{
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
