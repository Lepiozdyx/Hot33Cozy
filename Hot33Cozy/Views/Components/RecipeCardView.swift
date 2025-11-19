import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Color.backgroundEmphasis
                    
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
                .aspectRatio(3/4, contentMode: .fit)
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(recipe.isFavorite ? .favoriteHeart : .textSecondary)
                        .padding(8)
                        .background(Color.backgroundEmphasis.opacity(0.8))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.h3CardTitle)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "thermometer")
                            .font(.system(size: 10))
                        Text(recipe.temperature)
                            .font(.bodySecondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(recipe.brewingTime / 60)min")
                            .font(.bodySecondary)
                    }
                }
                .foregroundColor(.textSecondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.backgroundEmphasis)
        }
        .background(Color.backgroundSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentYellow, lineWidth: 2)
        )
    }
}

