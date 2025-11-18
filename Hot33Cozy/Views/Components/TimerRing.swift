import SwiftUI

struct TimerRing: View {
    let progress: Double
    let timeString: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: "5A5A5A"), lineWidth: 28)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.accentYellow, lineWidth: 28)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
            
            VStack(spacing: 8) {
                Text(timeString)
                    .font(.displayTimer)
                    .foregroundColor(.textPrimary)
                
                Rectangle()
                    .fill(Color.divider)
                    .frame(width: 60, height: 1)
            }
        }
        .frame(width: 200, height: 200)
    }
}

