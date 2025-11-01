import UIKit
    
    final class MovieQuizViewController: UIViewController {
        
        @IBOutlet weak private var imageView: UIImageView!
        
        @IBOutlet weak private var textLabel: UILabel!
        @IBOutlet weak private var couterLabel: UILabel!
        
        private let questionsAmount: Int = 10
        private var questionFactory: QuestionFactory = QuestionFactory()
        private var currentQuestion: QuizQuestion?
        
        private var currentQuestionIndex = 0
        private var correctAnswers = 0
        
        
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            imageView.layer.cornerRadius = 20
            if let question = questionFactory.requestNexQuestion() {
                currentQuestion = question
                let viewModel = convert(model: question)
                show(quiz: viewModel)
            }
        }
        
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let givenAnswer = true
            guard let currentQuestion = currentQuestion else { return }
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.currentAnswer, isButtonActive: sender)
            
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            let givenAnswer = false
            guard let currentQuestion = currentQuestion else { return }
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.currentAnswer, isButtonActive: sender)
        }
        
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(
                    named: model.image
                ) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
            )
        }
        
        private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            couterLabel.text = step.questionNumber
        }
        
        private func showAnswerResult(isCorrect: Bool, isButtonActive: UIButton) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.cornerRadius = 20
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
            isButtonActive.isEnabled = false
            
            if isCorrect {
                correctAnswers += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self]  in
                guard let self = self else { return }
                imageView.layer.borderWidth = .nan
                showNextQuestionOrResults()
                isButtonActive.isEnabled = true
            }
        }
        
        private func show(result: QuizResultsViewModel) {
            let alert = UIAlertController(
                title: result.title,
                message: result.text,
                preferredStyle: .alert
            )
            let alertAciton = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                correctAnswers = 0
                currentQuestionIndex = 0
                guard let currentQuestion = questionFactory.requestNexQuestion() else { return }
                let convertedQuestionView = convert(model: currentQuestion)
                show(quiz: convertedQuestionView)
            }
            
            alert.addAction(alertAciton)
            self.present(alert, animated: true)
        }
        
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
                let text = correctAnswers == questionsAmount ?
                "Поздравляем, вы ответили на 10 из 10!" :
                "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
                
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть еще раз"
                )
                show(result: result)
            } else {
                currentQuestionIndex += 1
                guard let nextQuestion = questionFactory.requestNexQuestion() else { return }
                currentQuestion = nextQuestion
                let convertedQuestionView = convert(model:  nextQuestion)
                show(quiz: convertedQuestionView)
            }
        }
        
    }


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
