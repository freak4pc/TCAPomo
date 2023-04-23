//
//  MainView.swift
//  Pomo
//
//  Created by Shai Mishali on 17/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct PomodoroView: View {
    var body: some View {
        VStack {
            VStack {
                TimerView(secondsElapsed: 0)

                HStack(spacing: 16) {
                    Button(
                        action: { },
                        label: {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                        }
                    )
                    .offset(y: -6)

                    TextField(
                        "",
                        text: .constant(""),
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
            .background(Color(red: 255.0 / 255, green: 45.0 / 255, blue: 80.0 / 255))

            ScrollView {
                TimerListItemView(item: TimerItem(id: UUID(), title: "Item 1", secondsElapsed: 1322, date: Date())) { }
                TimerListItemView(item: TimerItem(id: UUID(), title: "Item 2", secondsElapsed: 800, date: Date())) { }
                TimerListItemView(item: TimerItem(id: UUID(), title: "Item 3", secondsElapsed: 499, date: Date())) { }
            }
        }
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
