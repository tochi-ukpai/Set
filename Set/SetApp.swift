//
//  SetApp.swift
//  Set
//
//  Created by Theós on 08/05/2023.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetGame()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
