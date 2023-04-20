//
//  TimerSheet.swift
//  Pomo
//
//  Created by Shai Mishali on 18/04/2023.
//

import ComposableArchitecture

struct TimerSheet: Reducer {
    var body: some ReducerOf<TimerSheet> {
        Reduce { _, action in
            switch action {
            case .tappedRemove:
                return .none
            }
        }
    }

    enum Action: Equatable {
        case tappedRemove
    }

    struct State: Equatable {
        let timerItem: TimerItem
        var emoji: String {
            switch timerItem.secondsElapsed {
            case 5 ... 80:
                return "💪"
            case 80...:
                return "🤯"
            default:
                return "😇"
            }
        }
    }
}

/*
 struct Parent: Reducer {
 ///   struct State {
 ///     @PresentationState var child: Child.State?
 ///     // ...
 ///   }
 ///   enum Action {
 ///     case child(PresentationAction<Child.Action>)
 ///     // ...
 ///   }
 ///
 ///   var body: some Reducer<State, Action> {
 ///     Reduce { state, action in
 ///       // Core logic for parent feature
 ///     }
 ///     .ifLet(\.$child, action: /Action.child) {
 ///       Child()
 ///     }
 ///   }
 /// }
 */
