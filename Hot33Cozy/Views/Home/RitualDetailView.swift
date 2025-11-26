import SwiftUI

struct RitualDetailView: View {
    var ritual: Ritual
    @State private var navigateToTimer = false
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageData = ritual.imageData, let uiImage = UIImage(data: imageData) {
                        ZStack(alignment: .bottomLeading) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(10)
                            
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.8)],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(ritual.title)
                                    .font(.h1ScreenTitle)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: 24) {
                                    if let temperature = ritual.temperature {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Label {
                                                Text(temperature)
                                                    .font(.bodyPrimary)
                                                    .foregroundColor(.textSecondary)
                                            } icon: {
                                                Image(systemName: "thermometer")
                                                    .foregroundColor(.primaryRed)
                                            }
                                        }
                                    }
                                    
                                    if let brewingTime = ritual.brewingTime {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Label {
                                                Text("\(brewingTime / 60) min")
                                                    .font(.bodyPrimary)
                                                    .foregroundColor(.textSecondary)
                                            } icon: {
                                                Image(systemName: "clock")
                                                    .foregroundColor(.primaryRed)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.top, 8)
                        .frame(height: 230)
                    }
                    
                    if ritual.imageData == nil {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(ritual.title)
                                .font(.h1ScreenTitle)
                                .foregroundColor(.textPrimary)
                            
                            HStack(spacing: 24) {
                                if let temperature = ritual.temperature {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Label {
                                            Text(temperature)
                                                .font(.bodyPrimary)
                                                .foregroundColor(.textSecondary)
                                        } icon: {
                                            Image(systemName: "thermometer")
                                                .foregroundColor(.primaryRed)
                                        }
                                    }
                                }
                                
                                if let brewingTime = ritual.brewingTime {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Label {
                                            Text("\(brewingTime / 60) min")
                                                .font(.bodyPrimary)
                                                .foregroundColor(.textSecondary)
                                        } icon: {
                                            Image(systemName: "clock")
                                                .foregroundColor(.primaryRed)
                                        }
                                    }
                                }
                            }
                        }
                        .padding([.top, .horizontal])
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        if let notes = ritual.notes {
                            Text(notes)
                                .font(.h3CardTitle)
                                .foregroundColor(.textSecondary)
                        }
                        
                        HStack(spacing: 8) {
                            Text(ritual.date, style: .date)
                                .font(.h3CardTitle)
                                .foregroundColor(.textSecondary)
                            Text(ritual.date, style: .time)
                                .font(.h3CardTitle)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Button(action: { navigateToTimer = true }) {
                            Text("Start Timer")
                        }
                        .buttonStyle(.primary)
                        .padding(.top, 16)
                    }
                    .padding(.horizontal)
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

