import SwiftUI

struct DailyDealBanner: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.primaryRed
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daily Deal")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .padding(.leading, 20)
                        .background(Color.black)
                        .clipShape(Capsule())
                        .padding(.leading, -15)
                    
                    Text(recipe.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .padding(.leading, 20)
                }
                
                Spacer()
                
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        Circle()
                            .stroke(.green, lineWidth: 3)
                    }
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .padding(.trailing, -40)
            }
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

#Preview {
    DailyDealBanner(recipe: Recipe.mock)
        .background(Color.backgroundMain)
}

