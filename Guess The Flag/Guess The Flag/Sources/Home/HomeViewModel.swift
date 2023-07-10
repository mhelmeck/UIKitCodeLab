//
//  HomeViewModel.swift
//  Guess The Flag
//
//  Created by Maciej Helmecki on 07/07/2023.
//

import Combine
import Foundation

class HomeViewModel {
    // MARK: - Properties
    
    @Published private(set) var alertModel = AlertModel.empty
    @Published private(set) var homeTitle = String()
    @Published private(set) var flagOneImageName = String()
    @Published private(set) var flagTwoImageName = String()
    @Published private(set) var flagThreeImageName = String()
    
    private(set) var countries = [String]()
    private(set) var scores = [Int]()
    private(set) var correctAnswer = 0
    
    var score: Int { scores.reduce(0, +) }
    
    // MARK: - Init
    
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    func buttonTapped(tag: Int) {
        var title: String
        var message: String
        
        if tag == correctAnswer {
            scores.append(1)
            
            title = "Correct"
            message = "Your score is: \(score)"
        } else {
            scores.append(-1)
            
            title = "Wrong"
            message = "That’s the flag of \(countries[tag].capitalized) Your score is: \(score)"
        }
        
        alertModel = AlertModel(
            title: title,
            message: message,
            actionTitle: "Continue",
            action: { [weak self] in
                self?.play()
            }
        )
    }
    
    func play() {
        if scores.count == 5 {
            reset()
        } else {
            askQuestion()
        }
    }
    
    func askQuestion() {
        countries.shuffle()

        flagOneImageName = countries[0]
        flagTwoImageName = countries[1]
        flagThreeImageName = countries[2]

        correctAnswer = Int.random(in: 0...2)

        homeTitle = "Guess: \(countries[correctAnswer].capitalized)"
    }
    
    private func reset() {
        homeTitle = ""
        
        alertModel = AlertModel(
            title: "Congratulations!",
            message: "You've finished game with score: \(score).",
            actionTitle: "Play again",
            action: { [weak self] in
                self?.scores = []
                self?.play()
            }
        )
    }
    
    private func loadData() {
        [
            "estonia",
            "france",
            "germany",
            "ireland",
            "italy",
            "monaco",
            "nigeria",
            "poland",
            "russia",
            "spain",
            "uk",
            "us"
        ].forEach( { countries.append($0) })
    }
}

struct AlertModel {
    let title: String
    let message: String
    let actionTitle: String
    let action: (() -> Void)?
    
    static var empty: AlertModel {
        AlertModel(title: "", message: "", actionTitle: "", action: nil)
    }
}
