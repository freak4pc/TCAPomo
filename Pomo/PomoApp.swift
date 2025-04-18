//
//  PomoApp.swift
//  Pomo
//
//  Created by Shai Mishali on 13/01/2023.
//

import ComposableArchitecture
import SwiftUI
import XCTestDynamicOverlay

@main
struct PomoApp: App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                PomodoroView(
                    store: Store(
                        initialState: Pomodoro.State(secondsElapsed: 0),
                        reducer: { Pomodoro()._printChanges() }
                    )
                )
            }
        }
    }
}
