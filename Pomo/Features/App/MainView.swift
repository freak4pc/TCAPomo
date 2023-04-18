//
//  MainView.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
//    @State var progress = 0.0
//    @State var title = ""
//    @State var isActive = false
//    let clock = ContinuousClock()
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
                    }
                    .padding()
                }
                .background(Color(red: 255.0/255, green: 45.0/255, blue: 80.0/255).opacity(viewStore.isTimerActive ? 1 : 0.55))
                .animation(.default, value: viewStore.isTimerActive)

                ScrollView {
                    ForEach(1...100, id: \.self) { idx in
                        TimerListItemView(
                            title: "Random work item \(idx)",
                            date: Date().addingTimeInterval(-Double(idx) * 13244.0),
                            emoji: (["💜", nil, "💝", "🙌", "🙄"] as [String?])[idx % 5]
                        ) {
                            activate()
                        }
                    }
                }
            }
        }
    }

    func activate() {
//        withAnimation {
//            isActive.toggle()
//        }
//
//        Task {
//            let tick = 1.0 / 1500
//            for _ in 1...1500 {
//                try? await clock.sleep(until: .now.advanced(by: .seconds(1)))
//                self.progress += tick
//            }
//        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Store(initialState: Pomodoro.State(secondsElapsed: 1495), reducer: Pomodoro()))
    }
}
