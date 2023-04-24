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

