//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Ilman on 04.11.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(gameResult: GameResult)
}
