import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
//            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.h3CardTitle)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "thermometer")
                            .font(.system(size: 10))
                            .foregroundStyle(.red)
                        Text(recipe.temperature)
                            .font(.bodySecondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                            .foregroundStyle(.red)
                        Text("\(recipe.brewingTime / 60)min")
                            .font(.bodySecondary)
                    }
                }
                .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.accentYellow, lineWidth: 2)
        )
        .overlay(alignment: .topTrailing) {
            Button(action: onFavoriteToggle) {
                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(recipe.isFavorite ? .favoriteHeart : .white)
                    .shadow(color: .red, radius: 1)
            }
            .buttonStyle(.plain)
            .padding(8)
        }
        .frame(height: 260)
    }
}



#Preview {
    HStack {
        RecipeCardView(recipe: Recipe.mock, onFavoriteToggle: {})
        RecipeCardView(recipe: Recipe.mock, onFavoriteToggle: {})
    }
}
