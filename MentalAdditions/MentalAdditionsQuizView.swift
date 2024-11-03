import SwiftUI

struct MentalAdditionsQuizView: View {
    @State var viewModel = MentalAdditionsViewModel()
    @State private var feedbackMessage = ""
    @State private var feedbackColor: Color = .clear
    @State private var showFeedback = false
    @State private var timeElapsed: TimeInterval = 99
    @State private var isRunning = false
    @State private var showResultScreen = false
    @State private var isPreparing = true
    @State private var isRotating = false

    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple]), center: .center, startRadius: 0, endRadius: 500)
                .ignoresSafeArea()

            VStack {
                if !showResultScreen {
                    if isPreparing {
                        Image("MentalAdditions")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 65))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    withAnimation {
                                        self.isPreparing = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.startTimer()
                                    }
                                }
                            }
                    } else {
                        HStack() {
                            Image("MentalAdditions")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                                .rotationEffect(.degrees(isRotating ? 360 : 0))
                            Spacer()
                            Spacer()
                        }
                        .font(.system(size: 65))
                        .bold()
                        .padding()

                        Spacer()

                        let question = viewModel.questions[viewModel.currentQuestionIndex]
                        Text("\(question.firstTerm) + \(question.secondTerm)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.vertical, 20)
                        Spacer()
                        VStack {
                            Text(" ")
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
                                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 1.5, y: 5)
                                }
                            }
                            
                            if showFeedback {
                                Text(feedbackMessage)
                                    .foregroundColor(feedbackColor)
                                    .font(.title)
                                    .bold()
                            }
                        }
                        .frame(height: 310)
                        Spacer()
                        Spacer()
                        Spacer()
                        HStack {
                            Text(" ")
                            Spacer()
                            Text(" ")
                            Spacer()
                            Text("\(Int(timeElapsed))")
                                .foregroundStyle(LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                    startPoint: .bottomTrailing,
                                    endPoint: .topLeading
                                ))
                        }
                        .font(.system(size: 65))
                        .bold()
                        .padding()
                    }
                } else {
                    MentalAdditionsResultView(score: viewModel.score, onRestart: {
                        resetGame()
                    })
                }
            }
            .padding()
            .onDisappear(perform: stopTimer)
        }
    }

    private func startTimer() {
        guard !isPreparing else { return }
        
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

        feedbackMessage = isCorrect ? "+1" : "-1"
        feedbackColor = isCorrect ? .green : Color.red.opacity(0.8)

        if showFeedback {
            return
        }

        showFeedback = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
           if showFeedback {
                withAnimation(.easeInOut(duration: 1)) { // Durée d'animation pour la disparition
                    showFeedback = false
                }
           }
        }
    }

    private func resetGame() {
        viewModel.reset()
        showResultScreen = false
        isPreparing = true
        timeElapsed = 99
        stopTimer()
    }
}
