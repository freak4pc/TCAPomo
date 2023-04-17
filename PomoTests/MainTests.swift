@testable import Pomo
import XCTest
import ComposableArchitecture

@MainActor
final class MainTests: XCTestCase {
//    func testTimerEndsNaturally() async {
//        let store = TestStore(initialState: Main.State(timerProgress: 0.995), reducer: Main())
//
//        await store.send(.startTapped) { state in
//            state.isTimerActive = true
//        }
//    }

    func testTogglingTimer() async {
        let store = TestStore(initialState: Main.State(timerProgress: 0.995), reducer: Main())
        await store.send(.startTapped) { $0.isTimerActive = true }
        await store.send(.stopTapped) { $0.isTimerActive = false }
    }
}
