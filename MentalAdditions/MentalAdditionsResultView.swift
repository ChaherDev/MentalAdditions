import SwiftUI

struct MentalAdditionsResultView: View {
    let score: Int
    let onRestart: () -> Void
    @State private var scale: CGFloat = 1.0
    private let minScale: CGFloat = 0.8
    private let maxScale: CGFloat = 1.5
    
    var body: some View {
        VStack {
            Text("MentalAdditionsScore")
                .font(.title)
                .foregroundColor(.white)
                .bold()
              //  .padding()
            Spacer()
            Text("\(score)")
                .font(.system(size: 100))
                .foregroundStyle(.yellow)
                .scaleEffect(scale)
                .onAppear {
                    if score > 0 {
                        animate()
                    }
                }
                .padding()
                .bold()
            Spacer()
            Text(score > 0 ? "Screen and share your\nscore to your friends" : "Please, never share\nthis score to your friends.")
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Button(action: onRestart) {
                Text("RESTART")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
            }
        }
        .padding()
    }
    
    private func animate() {
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = maxScale
        }
    }
}
