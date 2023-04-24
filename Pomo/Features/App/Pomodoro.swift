//
//  Pomodoro.swift
//  Pomo
//
//  Created by Shai Mishali on 24/04/2023.
//

import Foundation
import ComposableArchitecture

struct Pomodoro: Reducer {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startTapped:
                state.isTimerActive = true
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: TimerCancelID.self)
            case .stopTapped:
                if state.secondsElapsed > 0 {
                    state.timers.append(.init(
                        id: uuid(),
                        title: state.timerTitle,
                        secondsElapsed: state.secondsElapsed,
                        date: date()
                    ))
                }

                state.isTimerActive = false
                state.timerTitle = ""
                state.secondsElapsed = 0
                return .cancel(id: TimerCancelID.self)
            case .timerTicked:
                state.secondsElapsed += 1

                if state.secondsElapsed == Constants.totalSeconds {
                    return .send(.stopTapped)
                }

                return .none
            case .timerItemTapped(let id):
                state.presentedTimer = state.timers[id: id].map(TimerSheet.State.init)
                return .none
            case .timerTitleChanged(let title):
                state.timerTitle = title
                return .none
            case .timerSheet(.presented(.tappedRemove)):
                if let removeId = state.presentedTimer?.timerItem.id {
                    state.timers.remove(id: removeId)
                }

                state.presentedTimer = nil
                return .none
            case .timerSheet:
                return .none
            }
        }
        .ifLet(\.$presentedTimer, action: /Action.timerSheet) {
            TimerSheet()
        }
    }

    enum Action: Equatable {
        case timerSheet(PresentationAction<TimerSheet.Action>)

        case startTapped
        case stopTapped
        case timerTitleChanged(String)
        case timerTicked
        case timerItemTapped(id: TimerItem.ID)
    }

    struct State: Equatable {
        @PresentationState var presentedTimer: TimerSheet.State?

        var timerTitle = ""
        var secondsElapsed = 0
        var isTimerActive = false
        var isStartDisabled: Bool { timerTitle.trimmingCharacters(in: .whitespaces).isEmpty }
        var timers = IdentifiedArrayOf<TimerItem>()
    }
}

private enum TimerCancelID {}
