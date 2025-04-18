import ComposableArchitecture
@testable import Pomo
import XCTest

let testDate = Date()
let testUUID = UUID(uuidString: "256FB11A-1557-4FE9-9954-693CA1678970")!
let clock = TestClock()

@MainActor
final class PomodoroTests: XCTestCase {
    func testTogglingTimer() async throws {
        let store = TestStore(
            initialState: Pomodoro.State(timerTitle: "My amazing work"),
            reducer: { Pomodoro()
        }) {
            $0.continuousClock = clock
            $0.uuid = UUIDGenerator { testUUID }
            $0.date = DateGenerator { testDate }
        }

        await store.send(.startTapped) {
            $0.isTimerActive = true
        }

        await clock.advance(by: .seconds(3))

        await store.receive(.timerTicked) { $0.secondsElapsed = 1 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 2 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 3 }

        await store.send(.stopTapped) {
            $0.isTimerActive = false
            $0.timerTitle = ""
            $0.secondsElapsed = 0
            $0.timers = [
                TimerItem(
                    id: testUUID,
                    title: "My amazing work",
                    secondsElapsed: 3,
                    date: testDate
                )
            ]
        }
    }

    func testTimerEndsNaturally() async throws {
        let store = TestStore(
            initialState: Pomodoro.State(
                timerTitle: "My amazing work",
                secondsElapsed: 1495
            ),
            reducer: { Pomodoro() }
        ) {
            $0.continuousClock = clock
            $0.uuid = UUIDGenerator { testUUID }
            $0.date = DateGenerator { testDate }
        }

        await store.send(.startTapped) {
            $0.isTimerActive = true
        }

        await clock.advance(by: .seconds(5))
        await store.receive(.timerTicked) { $0.secondsElapsed = 1496 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1497 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1498 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1499 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1500 }

        await store.receive(.stopTapped) {
            $0.timerTitle = ""
            $0.secondsElapsed = 0
            $0.isTimerActive = false
            $0.timers = [
                TimerItem(
                    id: testUUID,
                    title: "My amazing work",
                    secondsElapsed: 1500,
                    date: testDate
                )
            ]
        }
    }
}
