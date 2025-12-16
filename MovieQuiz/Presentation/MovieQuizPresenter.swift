//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Ilman on 17.12.2025.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var statisticService: StatisticServiceProtocol!
    var questionFactory: QuestionFactoryProtocol?
    
    init(statisticService: StatisticServiceProtocol = StatisticService()) {
        self.statisticService = statisticService
    }
    
    func isLastQuestionIndex() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // MARK: - Actions
    func yesButtonClicked(_ sender: UIButton) {
     didAnswer(isYes: true, sender: sender)
    }
    
    func noButtonClicked(_ sender: UIButton) {
        didAnswer(isYes: false, sender: sender)
    }
    
    private func didAnswer(isYes: Bool, sender: UIButton) {
        let givenAnswer = isYes
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.currentAnswer, isButtonActive: sender)
    }
    
    func didReciveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestionIndex() {
            let game = GameResult(correct: correctAnswers, total: questionsAmount, date: Date())
            statisticService.store(gameResult: game)
            let text = "Ваш результат: \(correctAnswers)/10\n Колличество сыграннхы квизов \(statisticService.gamesCount)\n Рекорд \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз"
            )
            viewController?.show(result: result)
        } else {
            self.switchToNextQuestion()
            viewController?.questionFactory?.requestNextQuestion()
        }
    }
    
}
