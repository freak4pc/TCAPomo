import ComposableArchitecture
import SwiftUI

struct TimerSheetView: View {
    let store: StoreOf<TimerSheet>

    var body: some View {
        VStack {
            Text("You've spent")
                .font(.largeTitle)

            let (minutes, seconds) = secondsToMinutes(store.timerItem.secondsElapsed)
            Text("\(minutes) minutes, \(seconds) seconds")
                .font(.title)
                .fontWeight(.bold)

            Text(store.emoji)
                .font(.system(size: 120, weight: .bold))
                .padding(24)

            Text("Working on")
                .font(.largeTitle)

            Text(store.timerItem.title)
                .font(.title)
                .fontWeight(.bold)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: { store.send(.tappedRemove) },
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
            TimerSheetView(
                store: .init(
                    initialState: .init(
                        timerItem: TimerItem(
                            id: UUID(),
                            title: "Hello",
                            secondsElapsed: 1337,
                            date: Date()
                        )
                    ),
                    reducer: { TimerSheet() }
                )
            )
        }
    }
}
