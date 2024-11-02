import SwiftUI

struct MentalAdditionsQuizView: View {
    @State private var feedbackMessage = ""
    @State private var feedbackColor: Color = .clear
    @State private var showFeedback = false
    @State private var timer: Timer?
    @State private var timeElapsed: TimeInterval = 99
    @State private var isRunning = false
    @State var viewModel = MentalAdditionsViewModel()
    @State private var showResultSheet = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                // Affichage du score
                HStack {
                    Text("🌟")
                    Spacer()
                    Text("\(viewModel.score)")
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.yellow, location: 0.0),
                                .init(color: Color(red: 1.0, green: 1.0, blue: 0.7), location: 0.25),
                                .init(color: Color.orange, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .bold()
                    Spacer()
                    Text("🌟")
                }
                .font(.system(size: 65))
                .padding()

                Spacer()

                // Affichage de la question ou du résultat
                if timeElapsed > 0 {
                    if viewModel.currentQuestionIndex < viewModel.questions.count {
                        displayQuestion()
                    } else {
                        // Si toutes les questions ont été répondues
                        Text("Fin du quiz")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                } else {
                    // Afficher le résultat si le temps est écoulé
                    Text("Temps écoulé")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }

                Spacer()
                HStack {
                    Text("\(Int(timeElapsed))")
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.orange, location: 0.0),
                                .init(color: Color.red, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    Spacer()
                    Text("⏱️")
                    Spacer()
                    Text("\(Int(timeElapsed))")
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.orange, location: 0.0),
                                .init(color: Color.red, location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                }
                .font(.system(size: 65))
                .bold()
                .padding()
            }
            .padding()
            .onAppear(perform: {
                startListeningForStartGameNotification()
            })
            .onDisappear(perform: stopTimer)
            .sheet(isPresented: $showResultSheet) {
                MentalAdditionsResultView(score: viewModel.score, timeElapsed: timeElapsed, onRestart: {
                    resetGame()
                    showResultSheet = false
                }, isFromTimeUp: timeElapsed <= 0)
            }
        }
    }

    private func displayQuestion() -> some View {
        let question = viewModel.questions[viewModel.currentQuestionIndex]
        return VStack {
            Text("\(question.firstTerm) + \(question.secondTerm) = ?")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding(.vertical, 20)

            ForEach(question.options, id: \.self) { option in
                Button(action: {
                    handleAnswerSelection(option)
                }) {
                    Text("\(option)")
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .font(.title2)
                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 5)
                }
            }

            if showFeedback {
                Text(feedbackMessage)
                    .foregroundColor(feedbackColor)
                    .font(.title)
                    .bold()
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut(duration: 0.5), value: showFeedback)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self.showFeedback = false
                            }
                        }
                    }
            }
        }
    }

    private func startListeningForStartGameNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("StartGame"), object: nil, queue: .main) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Attendre une seconde avant de démarrer le compteur
                startTimer()
            }
        }
    }

    public func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.isRunning {
                self.timeElapsed -= 1
                if self.timeElapsed <= 0 {
                    self.stopTimer()
                    // Afficher le résultat lorsque le temps est écoulé
                    DispatchQueue.main.async {
                        showResultSheet = true
                    }
                }
            }
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func handleAnswerSelection(_ answer: Int) {
        let isCorrect = viewModel.submitAnswer(answer)

        feedbackMessage = isCorrect ? "Correct" : "Wrong"
        feedbackColor = isCorrect ? .green : .red

        withAnimation {
            showFeedback = true
        }
    }

    private func resetGame() {
        viewModel.reset()
        timeElapsed = 99
        isRunning = false
        stopTimer()
    }
}
