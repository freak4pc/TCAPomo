//
//  TimerSheetView.swift
//  Pomo
//
//  Created by Shai Mishali on 18/04/2023.
//

import ComposableArchitecture
import SwiftUI

struct TimerSheetView: View {

    var body: some View {
            VStack {
                Text("You've spent")
                    .font(.largeTitle)

                let (minutes, seconds) = secondsToMinutes(1500)
                Text("\(minutes) minutes, \(seconds) seconds")
                    .font(.title)
                    .fontWeight(.bold)

                Text("🎁")
                    .font(.system(size: 120, weight: .bold))
                    .padding(24)

                Text("Working on")
                    .font(.largeTitle)

                Text("Timer Item")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: { },
                        label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.2))
    }
}

struct TimerSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerSheetView()
        }
    }
}
