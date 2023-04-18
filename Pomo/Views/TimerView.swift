//
//  TimerView.swift
//  Pomo
//
//  Created by Shai Mishali on 14/04/2023.
//

import SwiftUI

struct TimerView: View {
    var secondsElapsed: Int
    private var progress: Double { Double(secondsElapsed) / Double(Pomodoro.totalSeconds) }

    var body: some View {
        VStack {
            Image(systemName: "triangle.fill")
                .rotationEffect(.degrees(180))
                .foregroundColor(.white)
                .offset(y: 10)

            VStack {
                GeometryReader { geometry in
                    HStack {
                        ForEach(1...25, id: \.self) { idx in
                            Color.white
                                .frame(width: idx % 5 == 0 ? 5 : 2)

                            if idx != 25 {
                                Spacer()
                            }
                        }
                    }
                    .offset(x: geometry.size.width / 2)
                    .offset(x: -(geometry.size.width * progress))
                }
                .frame(height: 20)

                Text(secondsToMinutes(secondsElapsed))
                    .foregroundColor(.white)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(.top, 8)

                Spacer()
            }
            .offset(y: 20)
        }
        .frame(height: 120)
    }

    private func secondsToMinutes(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60

        let minPart = mins < 10 ? "0\(mins)" : "\(mins)"
        let secPart = secs < 10 ? "0\(secs)" : "\(secs)"

        return "\(minPart):\(secPart)"
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red

            TimerView(secondsElapsed: 375)

            TimerView(secondsElapsed: 1125)
        }
    }
}
