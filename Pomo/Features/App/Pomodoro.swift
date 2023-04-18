//
//  App.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import ComposableArchitecture

struct Pomodoro: Reducer {
    @Dependency(\.continuousClock) var clock
    static let totalSeconds = 25 * 60
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startTapped:
                state.isTimerActive = true
                return .run { send in // [currentProgress = state.timerProgress] send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: TimerCancelID.self)
            case .timerTicked:
                state.secondsElapsed += 1

                if state.secondsElapsed == Self.totalSeconds {
                    return .send(.stopTapped)
                }

                return .none
            case .stopTapped:
                state.isTimerActive = false
                state.secondsElapsed = 0
                state.timerTitle = ""

                return .cancel(id: TimerCancelID.self)
            case .timerTitleChanged(let newTitle):
                state.timerTitle = newTitle
                return .none
            }
        }
    }

    enum Action: Equatable {
        case timerTitleChanged(String)
        case startTapped
        case stopTapped
        case timerTicked
    }

    struct State: Equatable {
        var timerTitle = ""
        var isTimerActive = false
        var secondsElapsed = 0
        var isStartDisabled: Bool { timerTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

private enum TimerCancelID {}
