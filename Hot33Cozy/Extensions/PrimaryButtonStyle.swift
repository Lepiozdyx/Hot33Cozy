import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.buttonLabel)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 56)
            .background(configuration.isPressed ? Color(hex: "B32300") : Color.primaryRed)
            .cornerRadius(10)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

