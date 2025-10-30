import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let currentAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    final class MovieQuizViewController: UIViewController {
        
        @IBOutlet weak private var imageView: UIImageView!
        
        @IBOutlet weak private var textLabel: UILabel!
        @IBOutlet weak private var couterLabel: UILabel!
        
        private var currentQuestionIndex = 0
        private var correctAnswers = 0
        private let questions: [QuizQuestion] = [
            QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?" , currentAnswer: true),
            QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
            QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
            QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
            QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true,),
            QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: true),
            QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false),
            QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false),
            QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false),
            QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", currentAnswer: false)
        ]
        
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            imageView.layer.cornerRadius = 20
            let currentQuestion = questions[currentQuestionIndex]
            let convertedQuestion = convert(model: currentQuestion)
            show(quiz: convertedQuestion)
        }
        
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == questions[currentQuestionIndex].currentAnswer, isButtonActive: sender)
            
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == questions[currentQuestionIndex].currentAnswer, isButtonActive: sender)
        }
        
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(
                    named: model.image
                ) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
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
            isButtonActive.isEnabled.toggle()
            
            if isCorrect {
                correctAnswers += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self]  in
                imageView.layer.borderWidth = .nan
                showNextQuestionOrResults()
                isButtonActive.isEnabled.toggle()
            }
        }
        
        private func show(result: QuizResultsViewModel) {
            let alert = UIAlertController(
                title: result.title,
                message: result.text,
                preferredStyle: .alert
            )
            let alertAciton = UIAlertAction(title: result.buttonText, style: .default) { [self] _ in
                correctAnswers = 0
                currentQuestionIndex = 0
                let convertedQuestionView = convert(model: questions[currentQuestionIndex])
                show(quiz: convertedQuestionView)
            }
            
            alert.addAction(alertAciton)
            self.present(alert, animated: true)
        }
        
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questions.count - 1 {
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: "Ваш результат \(correctAnswers) из \(questions.count)",
                    buttonText: "Сыграть еще раз"
                )
                show(result: result)
            } else {
                currentQuestionIndex += 1
                let convertedQuestionView = convert(model: questions[currentQuestionIndex])
                show(quiz: convertedQuestionView)
            }
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
