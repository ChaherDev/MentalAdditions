import SwiftUI
import Observation

@Observable
class MentalAdditionsViewModel {
    var score = 0
    var currentQuestionIndex = 0
    var questions: [MentalAdditionsQuestion]
    var isGameFinished: Bool = false

    init() {
        self.questions = MentalAdditionsViewModel.generateQuestions()
    }
    
    func submitAnswer(_ answer: Int) -> Bool {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == answer
        if isCorrect { score += 1 }
        currentQuestionIndex += 1
        
        // Vérifier si toutes les questions ont été répondues
        if currentQuestionIndex >= questions.count {
            isGameFinished = true
        }
        return isCorrect
    }
    
    func reset() {
        score = 0
        currentQuestionIndex = 0
        questions = MentalAdditionsViewModel.generateQuestions()
        isGameFinished = false
    }

    static func generateQuestions() -> [MentalAdditionsQuestion] {
        var questions = [MentalAdditionsQuestion]()
        for _ in 1...20 { // Générer un nombre illimité de questions
            let firstTerm = Int.random(in: 1...10_000)
            let secondTerm = Int.random(in: 1...10_000)
            questions.append(MentalAdditionsQuestion(firstTerm: firstTerm, secondTerm: secondTerm))
        }
        return questions.shuffled() // Mélanger les questions
    }
}
