//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Ilman on 04.11.2025.
//

import Foundation

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct < another.correct
    }
}
