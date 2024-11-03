import SwiftUI

struct MentalAdditionsResultView: View {
    let score: Int
    let onRestart: () -> Void
    @State private var scale: CGFloat = 1.0
    private let minScale: CGFloat = 0.8
    private let maxScale: CGFloat = 1.5
    
    var body: some View {
        VStack {
            Text("Your Score")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding()
            Spacer()
            Text("\(score)")
                .font(.system(size: 100))
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.red, Color.yellow, Color.red]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .scaleEffect(scale)
                .onAppear {
                    animate()
                }
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: onRestart) {
                Text("Restart")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.largeTitle)
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
