import SwiftUI

struct UnderlinedTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.h2SectionTitle)
                .foregroundColor(.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.bodyPrimary)
                .foregroundColor(.textSecondary)
                .accentColor(.accentYellow)
            
            Rectangle()
                .fill(Color.divider)
                .frame(height: 1)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Color.backgroundMain
            .ignoresSafeArea()
        
        UnderlinedTextField(label: "Label", text: .constant("Text"), placeholder: "Placeholder")
            .padding()
    }
}
