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
        if isCorrect {
            score += 1
        } else {
            score -= 1
        }
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
        for _ in 1...2000 {
            let firstTerm = Int.random(in: 0...499999)
            let secondTerm = Int.random(in: 0...499999)
            questions.append(MentalAdditionsQuestion(firstTerm: firstTerm, secondTerm: secondTerm))
        }
        return questions.shuffled() // Mélanger les questions
    }
}
