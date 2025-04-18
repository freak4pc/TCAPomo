//
//  MainView.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct PomodoroView: View {
    @Bindable var store: StoreOf<Pomodoro>

    var body: some View {
        VStack {
            VStack {
                TimerView(secondsElapsed: store.secondsElapsed)

                HStack(spacing: 16) {
                    Button(
                        action: {
                            if store.isTimerActive {
                                store.send(.stopTapped)
                            } else {
                                store.send(.startTapped)
                            }
                        },
                        label: {
                            Image(systemName: store.isTimerActive ? "stop.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                                .opacity(store.isStartDisabled ? 0.55 : 1.0)
                        }
                    )
                    .offset(y: -6)
                    .disabled(store.isStartDisabled)
                    .animation(.default, value: store.isStartDisabled)

                    TextField(
                        "",
                        text: $store.timerTitle.sending(\.timerTitleChanged),
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
                    .disabled(store.isTimerActive)
                }
                .padding()
            }
            .background(Color(red: 255.0 / 255, green: 45.0 / 255, blue: 80.0 / 255))

            ScrollView {
                ForEach(store.timers) { timer in
                    TimerListItemView(item: timer) {
                        store.send(.timerItemTapped(id: timer.id))
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.presentedTimer, action: \.timerSheet)) { store in
            NavigationView {
                TimerSheetView(store: store)
            }
        }
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(
            store: .init(
                initialState: Pomodoro.State(),
                reducer: { Pomodoro() }
            )
        )
    }
}
