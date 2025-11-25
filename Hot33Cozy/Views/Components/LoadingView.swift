import SwiftUI

struct LoadingView: View {
    @State private var loading: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.primaryRed.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Image(.slogan)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                
                Spacer()
                
                Capsule()
                    .foregroundStyle(.white.opacity(0.4))
                    .frame(maxWidth: 250, maxHeight: 20)
                    .overlay {
                        Capsule()
                            .stroke(.green, lineWidth: 2)
                    }
                    .overlay(alignment: .leading) {
                        Capsule()
                            .foregroundStyle(Color.accentYellow)
                            .frame(width: 248 * loading, height: 18)
                            .padding(.horizontal, 1)
                    }
                    .overlay {
                        Text("Loading...")
                            .font(.labelSmall)
                            .foregroundStyle(Color.primaryRed)
                    }
            }
            .padding(.bottom)
        }
        .onAppear {
            withAnimation(.linear(duration: 3)) {
                loading = 1
            }
        }
    }
}

#Preview {
    LoadingView()
}
