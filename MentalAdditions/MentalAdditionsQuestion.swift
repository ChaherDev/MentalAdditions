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
        let optionCount = UIScreen.main.bounds.width > 375 ? 6 : 5
        while generatedOptions.count < optionCount {
            let randomValue = Int.random(in: 0...499999)
            generatedOptions.insert(randomValue)
        }

        self.options = Array(generatedOptions).shuffled()
    }
}
