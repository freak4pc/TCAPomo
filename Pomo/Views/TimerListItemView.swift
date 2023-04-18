//
//  TimerListItemView.swift
//  Pomo
//
//  Created by Shai Mishali on 15/04/2023.
//

import SwiftUI

struct TimerListItemView: View {
    let item: TimerItem
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Spacer(minLength: 16)
                    VStack {
                        Text(item.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .fontWeight(.medium)

                        HStack(spacing: 4) {
                            Image(systemName: "timer")

                            let (minutes, seconds) = secondsToMinutes(item.secondsElapsed)
                            Text(minutes == "00" ? "\(seconds)s" : "\(minutes)m\(seconds)s")

                            Image(systemName: "calendar")

                            Text(item.date, format: .relative(presentation: .named))

                            Spacer()
                        }
                        .font(.footnote)
                    }

                    Spacer(minLength: 16)
                }
                .padding(16)
                .background(
                    LinearGradient(colors: [
                        Color.red.opacity(0.55),
                        Color.red], startPoint: .top, endPoint: .bottom)
                        .mask { RoundedRectangle(cornerRadius: 6, style: .continuous) }
                        .padding(.horizontal, 16)
                )
                .foregroundColor(.white)
            }
        )
        .buttonStyle(.sinking)
    }
}

struct TimerListItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimerListItemView(item: .init(id: UUID(), title: "Hello", secondsElapsed: 13377, date: Date())) { }
        }
    }
}
