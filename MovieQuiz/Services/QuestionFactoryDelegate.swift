//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ilman on 02.11.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReciveNextQuestion(question: QuizQuestion?)
}
