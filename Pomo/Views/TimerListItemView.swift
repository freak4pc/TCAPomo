//
//  TimerListItemView.swift
//  Pomo
//
//  Created by Shai Mishali on 15/04/2023.
//

import SwiftUI

struct TimerListItemView: View {
    let title: String
    let date: Date
    let emoji: String?
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Spacer(minLength: 16)
                    VStack {
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .fontWeight(.medium)

                        HStack(spacing: 4) {
                            Image(systemName: "timer")

                            Text("12m55s")

                            Image(systemName: "calendar")

                            Text(date, format: .relative(presentation: .named))

                            Spacer()
                        }
                        .font(.footnote)
                    }

                    Spacer()

                    if let emoji {
                        Text(emoji)
                            .font(.system(size: 24))
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
            TimerListItemView(title: "Worked on thing", date: Date().addingTimeInterval(-123123), emoji: nil) { }
            
            TimerListItemView(title: "Worked on thing", date: Date().addingTimeInterval(-123123), emoji: "😍") {}
        }
    }
}
