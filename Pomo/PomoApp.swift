//
//  PomoApp.swift
//  Pomo
//
//  Created by Shai Mishali on 13/01/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct PomoApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(store: Store(initialState: Main.State(), reducer: Main()._printChanges()))
        }
    }
}
