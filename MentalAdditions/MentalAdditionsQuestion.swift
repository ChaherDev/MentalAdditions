import SwiftUI

struct MentalAdditionsQuestion {
    let firstTerm: Int
    let secondTerm: Int
    var correctAnswer: Int {
        return firstTerm + secondTerm
    }
    let options: [Int]

    init(firstTerm: Int, secondTerm: Int) {
        self.firstTerm = firstTerm
        self.secondTerm = secondTerm

        var generatedOptions: Set<Int> = [firstTerm + secondTerm]
        while generatedOptions.count < 4 {
            let randomValue = Int.random(in: 0...499999)
            generatedOptions.insert(randomValue)
        }

        self.options = Array(generatedOptions).shuffled()
    }
}
