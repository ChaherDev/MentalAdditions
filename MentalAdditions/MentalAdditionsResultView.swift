import SwiftUI

struct MentalAdditionsResultView: View {
    let score: Int
    let onRestart: () -> Void
    
    var body: some View {
        VStack {
            Text("Time's Up!")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding()
            
            Text("Your Score is: \(score)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .multilineTextAlignment(.center)
            
            Button(action: onRestart) {
                Text("Restart")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title2)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
            }
        }
        .padding()
    }
}
