import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var navigateToTimer = false
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image with Overlay
                    ZStack(alignment: .bottom) {
                        Image(recipe.imageName)
                            .resizable()
                            .scaledToFit()
                        
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.8)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.name)
                                .font(.h1ScreenTitle)
                                .foregroundColor(.textPrimary)
                            
                            HStack(spacing: 16) {
                                Label {
                                    Text(recipe.temperature)
                                        .font(.bodySecondary)
                                        .foregroundColor(.textSecondary)
                                } icon: {
                                    Image(systemName: "thermometer")
                                        .foregroundColor(.primaryRed)
                                }
                                
                                Label {
                                    Text("\(recipe.brewingTime / 60) min")
                                        .font(.bodySecondary)
                                        .foregroundColor(.textSecondary)
                                } icon: {
                                    Image(systemName: "clock")
                                        .foregroundColor(.primaryRed)
                                }
                                
                                Spacer()
                                
                                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(recipe.isFavorite ? .favoriteHeart : .textSecondary)
                                    .font(.title2)
                            }
                        }
                        .padding(16)
                    }
                    .frame(height: 230)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Ingredients
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(.h2SectionTitle)
                                .foregroundColor(.textPrimary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(.textSecondary)
                                        Text(ingredient)
                                            .font(.bodyPrimary)
                                            .foregroundColor(.textSecondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(.h2SectionTitle)
                                .foregroundColor(.textPrimary)
                            
                            Text(recipe.description)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .lineSpacing(4)
                        }
                    }
                    .padding(20)
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { navigateToTimer = true }) {
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
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 100)
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            id: 1,
            name: "Creamy Homemade Hot Cocoa",
            temperature: "95°C",
            brewingTime: 600,
            ingredients: [
                "¾ Cup White Sugar",
                "⅓ Cup Unsweetened Cocoa Powder",
                "1 Pinch Salt",
                "⅓ Cup Boiling Water",
                "3 ½ Cups Milk",
                "¾ Teaspoon Vanilla Extract",
                "½ Cup Half-And-Half Cream"
            ],
            description: "1. Gather The Ingredients.\n2. Combine Sugar, Cocoa Powder, And Salt In A Saucepan; Add Boiling Water And Whisk Until Smooth. Bring Mixture To A Simmer, Stirring Continuously To Prevent Scorching, And Cook For 2 Minutes.\n3. Stir In Milk And Heat Until Very Hot Without Boiling.\n4. Remove From Heat; Add Vanilla.\n5. Add Cream To Each Mug To Help Cool Cocoa To Drinking Temperature Then Divide Hot Cocoa Between 4 Mugs.\n6. Serve Hot And Enjoy!",
            imageName: "CreamyHomemadeHotCocoa"
        ))
    }
}
