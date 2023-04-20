//
//  App.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import ComposableArchitecture
import Foundation

struct Pomodoro: Reducer {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date

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
                state.secondsElapsed += 12

                if state.secondsElapsed == Self.totalSeconds {
                    return .send(.stopTapped)
                }

                return .none
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
                state.secondsElapsed = 0
                state.timerTitle = ""

                return .cancel(id: TimerCancelID.self)
            case .timerTitleChanged(let newTitle):
                state.timerTitle = newTitle
                return .none
            case .timerSheet(.presented(.tappedRemove)):
                if let removedId = state.presentedTimer?.timerItem.id {
                    state.timers.remove(id: removedId)
                }
                state.presentedTimer = nil
                return .none
            case .timerSheet:
                return .none
            case .timerItemTapped(let id):
                state.presentedTimer = state.timers[id: id].map(TimerSheet.State.init(timerItem:))
                return .none
            }
        }
        .ifLet(\.$presentedTimer, action: /Action.timerSheet) {
            TimerSheet()
        }
    }

    enum Action: Equatable {
        case timerSheet(PresentationAction<TimerSheet.Action>)

        case timerTitleChanged(String)
        case startTapped
        case stopTapped
        case timerTicked
        case timerItemTapped(id: TimerItem.ID)
    }

    struct State: Equatable {
        @PresentationState var presentedTimer: TimerSheet.State?

        var timers = IdentifiedArrayOf<TimerItem>()
        var timerTitle = ""
        var isTimerActive = false
        var secondsElapsed = 0
        var isStartDisabled: Bool { timerTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

private enum TimerCancelID {}
