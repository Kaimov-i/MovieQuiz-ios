//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Ilman on 23.12.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkEror(message: String)
}
