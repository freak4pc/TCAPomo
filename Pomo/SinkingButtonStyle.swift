import SwiftUI

struct SinkingButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var theme

    let height: CGFloat = 48
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 16))
            .frame(maxWidth: .infinity, minHeight: height)
            .foregroundColor(.black)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == SinkingButtonStyle {
    /// A button style that sinks on touch
    static var sinking: SinkingButtonStyle { .init() }
}
