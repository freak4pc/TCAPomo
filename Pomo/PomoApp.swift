//
//  PomoApp.swift
//  Pomo
//
//  Created by Shai Mishali on 13/01/2023.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@main
struct PomoApp: App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                PomodoroView(store: Store(initialState: Pomodoro.State(), reducer: Pomodoro()._printChanges()))
            }
        }
    }
}
