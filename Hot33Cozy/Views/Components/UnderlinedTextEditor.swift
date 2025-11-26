//
//  UnderlinedTextField 2.swift
//  Hot33Cozy
//
//  Created by Alex on 26.11.2025.
//


import SwiftUI

struct UnderlinedTextEditor: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.h2SectionTitle)
                .foregroundColor(.textPrimary)

            TextEditor(text: $text)
                .font(.bodyPrimary)
                .foregroundColor(.textSecondary)
                .accentColor(.accentYellow)
                .frame(minHeight: 30, maxHeight: 100)
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .overlay(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.bodyPrimary)
                            .foregroundColor(.textSecondary)
                    }
                }
            
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
        
        UnderlinedTextEditor(label: "Label", text: .constant("Text"), placeholder: "Placeholder")
            .padding()
    }
}
