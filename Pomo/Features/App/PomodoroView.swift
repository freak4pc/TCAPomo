//
//  MainView.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct PomodoroView: View {
    let store: StoreOf<Pomodoro>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                VStack {
                    TimerView(secondsElapsed: viewStore.secondsElapsed)

                    HStack(spacing: 16) {
                        Button(
                            action: {
                                if viewStore.isTimerActive {
                                    viewStore.send(.stopTapped)
                                } else {
                                    viewStore.send(.startTapped)
                                }
                            },
                            label: {
                                Image(systemName: viewStore.isTimerActive ? "stop.circle.fill" : "play.circle.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                                    .opacity(viewStore.isStartDisabled ? 0.55 : 1)
                            }
                        )
                        .offset(y: -6)
                        .disabled(viewStore.isStartDisabled)
                        .animation(.default, value: viewStore.isStartDisabled)

                        TextField(
                            "",
                            text: viewStore.binding(get: \.timerTitle, send: { .timerTitleChanged($0) }),
                            prompt: Text("Set a goal")
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .padding(.bottom, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .strokeBorder(.white, lineWidth: 2)
                                .offset(y: -6)
                        )
                        .disabled(viewStore.isTimerActive)
                    }
                    .padding()
                }
                .background(Color(red: 255.0 / 255, green: 45.0 / 255, blue: 80.0 / 255).opacity(viewStore.isTimerActive ? 1 : 0.55))
                .animation(.default, value: viewStore.isTimerActive)

                ScrollView {
                    ForEach(viewStore.timers) { timer in
                        TimerListItemView(item: timer) {
                            viewStore.send(.timerItemTapped(id: timer.id))
                        }
                    }
                }
            }
        }
        .sheet(
            store: store.scope(
                state: \.$presentedTimer,
                action: Pomodoro.Action.timerSheet
            ),
            content: { store in
                NavigationView {
                    TimerSheetView(store: store)
                }
            }
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(store: Store(initialState: Pomodoro.State(secondsElapsed: 1495), reducer: Pomodoro()))
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
