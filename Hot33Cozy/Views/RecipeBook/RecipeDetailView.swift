import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var navigateToTimer = false
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ZStack {
                        Rectangle()
                            .fill(Color.backgroundEmphasis)
                            .frame(height: 300)
                            .cornerRadius(10)
                        
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.textMuted)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(recipe.name)
                            .font(.h1ScreenTitle)
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: 24) {
                            HStack(spacing: 8) {
                                Image(systemName: "thermometer")
                                    .foregroundColor(.textMuted)
                                Text(recipe.temperature)
                                    .font(.bodySecondary)
                                    .foregroundColor(.textSecondary)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .foregroundColor(.textMuted)
                                Text("\(recipe.brewingTime / 60) min")
                                    .font(.bodySecondary)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.h2SectionTitle)
                                .foregroundColor(.textPrimary)
                            
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(.textSecondary)
                                    Text(ingredient)
                                        .font(.bodyPrimary)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.h2SectionTitle)
                                .foregroundColor(.textPrimary)
                            
                            Text(recipe.description)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "timer")
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToTimer) {
            TimerView(
                presetTime: recipe.brewingTime,
                drinkName: recipe.name,
                autoStart: true
            )
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            id: 1,
            name: "Green Tea",
            temperature: "80°C",
            brewingTime: 180,
            ingredients: ["Green tea leaves (2g)", "Hot water (200ml)"],
            description: "Pour hot water over green tea leaves and steep for 2-3 minutes.",
            imageName: "green-tea"
        ))
    }
}

