//
//  ContentView.swift
//  Pomo
//
//  Created by Shai Mishali on 13/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AppView()
        }
        .padding(0)
    }
}

struct AppView: View {
    @State var progress = 0.0
    @State var title = ""
    @State var isActive = false
    let clock = ContinuousClock()

    var body: some View {
        VStack {
            VStack {
                TimerView(progress: progress)

                HStack(spacing: 16) {
                    Button(
                        action: {
                            isActive.toggle()
//
                            Task {
                                let tick = 1.0 / 1500
                                for _ in 1...1500 {
                                    try? await clock.sleep(until: .now.advanced(by: .seconds(1)))
                                    self.progress += tick
                                }
                            }
                        },
                        label: {
                            Image(systemName: isActive ? "stop.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.white)
                        }
                    )
                    .offset(y: -6)

                    TextField(
                        "",
                        text: $title,
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
            .background(Color(red: 255.0/255, green: 45.0/255, blue: 80.0/255).opacity(isActive ? 1 : 0.55))
            .animation(.default, value: isActive)

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

    func activate() {
        withAnimation {
            isActive.toggle()
        }

        Task {
            let tick = 1.0 / 1500
            for _ in 1...1500 {
                try? await clock.sleep(until: .now.advanced(by: .seconds(1)))
                self.progress += tick
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
