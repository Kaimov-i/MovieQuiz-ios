//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ilman on 04.11.2025.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
    
    var totalCorrectAnswer: Int  {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        } set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            GameResult(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            totalCorrectAnswer += storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
            totalQuestionsAsked += storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
            return Double(totalCorrectAnswer) / Double(totalQuestionsAsked) * 100.0
        }
        set {
            storage.set(newValue, forKey: "totalAccuracy")
        }
    }
    
    func store(gameResult: GameResult) {
        totalCorrectAnswer += gameResult.correct
        totalQuestionsAsked += gameResult.total
        gamesCount += 1
        if bestGame.isBetterThan(gameResult) {
            bestGame = gameResult
        }
    }
}







