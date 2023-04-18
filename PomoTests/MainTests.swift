@testable import Pomo
import XCTest
import ComposableArchitecture

@MainActor
final class MainTests: XCTestCase {
    let clock = TestClock()

    func testTogglingTimer() async {
        let store = TestStore(initialState: Main.State(), reducer: Main()) {
            $0.continuousClock = clock
        }

        await store.send(.startTapped) { $0.isTimerActive = true }
        await store.send(.stopTapped) { $0.isTimerActive = false }
    }

    func testTimerEndsNaturally() async {
        let store = TestStore(initialState: Main.State(secondsElapsed: 1495), reducer: Main()) {
            $0.continuousClock = clock
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
        }
    }
}
