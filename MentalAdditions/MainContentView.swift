import SwiftUI

struct MainContentView: View {
    @State private var isGameStarted = false

    var body: some View {
        NavigationView {
            MentalAdditionsQuizView(viewModel: MentalAdditionsViewModel())
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    // Attendre une seconde avant de commencer le jeu
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        isGameStarted = true
                        NotificationCenter.default.post(name: NSNotification.Name("StartGame"), object: nil)
                    }
                }
        }
    }
}
