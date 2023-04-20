import ComposableArchitecture
@testable import Pomo
import XCTest

let testDate = Date()
let testUUID = UUID(uuidString: "256FB11A-1557-4FE9-9954-693CA1678970")!

@MainActor
final class PomodoroTests: XCTestCase {
    let clock = TestClock()

    func testTogglingTimer() async {
        let store = TestStore(initialState: Pomodoro.State(timerTitle: "My amazing item"), reducer: Pomodoro()) {
            $0.continuousClock = clock
            $0.uuid = UUIDGenerator { testUUID }
            $0.date = DateGenerator { testDate }
        }

        await store.send(.startTapped) { $0.isTimerActive = true }
        await store.send(.stopTapped) {
            $0.isTimerActive = false
            $0.timerTitle = ""
        }
    }

    func testTimerEndsNaturally() async {
        let store = TestStore(
            initialState: Pomodoro.State(
                timerTitle: "My amazing item",
                secondsElapsed: 1495
            ),
            reducer: Pomodoro()
        ) {
            $0.continuousClock = clock
            $0.uuid = UUIDGenerator { testUUID }
            $0.date = DateGenerator { testDate }
        }

        await store.send(.startTapped) { $0.isTimerActive = true }

        await clock.advance(by: .seconds(5))
        await store.receive(.timerTicked) { $0.secondsElapsed = 1496 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1497 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1498 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1499 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1500 }

        // Timer should auto-stop once we reach 25 minutes
        await clock.advance(by: .seconds(1))
        await store.receive(.stopTapped) {
            $0.secondsElapsed = 0
            $0.isTimerActive = false
            $0.timerTitle = ""
            $0.timers = [
                .init(id: testUUID, title: "My amazing item", secondsElapsed: 1500, date: testDate),
            ]
        }
    }
}
