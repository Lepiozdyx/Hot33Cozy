import SwiftUI

struct RitualDetailView: View {
    let ritual: Ritual
    @State private var navigateToTimer = false
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let imageData = ritual.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(ritual.title)
                            .font(.h1ScreenTitle)
                            .foregroundColor(.textPrimary)
                        
                        if let notes = ritual.notes {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.h2SectionTitle)
                                    .foregroundColor(.textPrimary)
                                Text(notes)
                                    .font(.bodyPrimary)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Date & Time")
                                    .font(.bodySecondary)
                                    .foregroundColor(.textMuted)
                                Text(ritual.date, style: .date)
                                    .font(.bodyPrimary)
                                    .foregroundColor(.textSecondary)
                                Text(ritual.date, style: .time)
                                    .font(.bodyPrimary)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            if let temperature = ritual.temperature {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Temperature")
                                        .font(.bodySecondary)
                                        .foregroundColor(.textMuted)
                                    Text(temperature)
                                        .font(.bodyPrimary)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            
                            if let brewingTime = ritual.brewingTime {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Brewing Time")
                                        .font(.bodySecondary)
                                        .foregroundColor(.textMuted)
                                    Text("\(brewingTime / 60) min")
                                        .font(.bodyPrimary)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        
                        Button(action: { navigateToTimer = true }) {
                            Text("Start Timer")
                        }
                        .buttonStyle(.primary)
                        .padding(.top, 16)
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToTimer) {
            TimerView(
                presetTime: ritual.brewingTime ?? 900,
                drinkName: ritual.title,
                autoStart: true
            )
        }
    }
}

#Preview {
    NavigationStack {
        RitualDetailView(ritual: Ritual(
            title: "Green Tea",
            notes: "After morning walk",
            date: Date(),
            temperature: "80°C",
            brewingTime: 180
        ))
    }
}

