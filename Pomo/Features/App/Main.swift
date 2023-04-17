//
//  App.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import ComposableArchitecture

struct Main: Reducer {
    let clock = ContinuousClock()
    private static let timerTicks = Double(25 * 60)
    private static let timerTickProgress = 1 / Self.timerTicks

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
                state.timerProgress += 1 / (25 * 60)

                if state.timerProgress >= 1.0 {
                    return .send(.stopTapped)
                }

                return .none
            case .stopTapped:
                state.isTimerActive = false
                state.timerProgress = 0
                state.timerTitle = ""

                return .cancel(id: TimerCancelID.self)
            case .timerTitleChanged(let newTitle):
                state.timerTitle = newTitle
                return .none
            }
        }
    }

    enum Action {
        case timerTitleChanged(String)
        case startTapped
        case stopTapped
        case timerTicked
    }

    struct State: Equatable {
        var timerTitle = ""
        var isTimerActive = false
        var timerProgress = 0.0
        var isStartDisabled: Bool { timerTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

private enum TimerCancelID {}
