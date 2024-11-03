import SwiftUI

struct MentalAdditionsQuizView: View {
    @State private var feedbackMessage = ""
    @State private var feedbackColor: Color = .clear
    @State private var showFeedback = false
    @State private var timeElapsed: TimeInterval = 99
    @State private var isRunning = false
    @State private var showResultScreen = false
    @State var viewModel = MentalAdditionsViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("❔")
                }
                .font(.system(size: 75))
                .foregroundStyle(.green)
//                .foregroundStyle(LinearGradient(
//                    gradient: Gradient(colors: [Color.yellow, Color.red]),
//                    startPoint: .bottom, endPoint: .top
//                ))
                .bold()
                .padding()

                Spacer()

                if !showResultScreen {
                    // Boucle infinie des questions
                    let question = viewModel.questions[viewModel.currentQuestionIndex]
                    Text("\(question.firstTerm) + \(question.secondTerm)")
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
                } else {
                    MentalAdditionsResultView(score: viewModel.score, onRestart: {
                        resetGame()
                    })
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("\(Int(timeElapsed))")
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("\(Int(timeElapsed))")
                    Spacer()
                    
                }
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.red]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .font(.system(size: 65))
                .bold()
                .padding()
            }
            .padding()
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
        }
    }

    private func startTimer() {
        isRunning = true
        timeElapsed = 99
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard self.isRunning else {
                timer.invalidate()
                return
            }
            if self.timeElapsed > 0 {
                self.timeElapsed -= 1
            } else {
                self.showResultScreen = true
                self.isRunning = false
            }
        }
    }

    private func stopTimer() {
        isRunning = false
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
        showResultScreen = false
        startTimer()
    }
}
