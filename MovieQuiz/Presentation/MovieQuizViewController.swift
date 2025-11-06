import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var couterLabel: UILabel!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticService()
        
        imageView.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        self.questionFactory?.requestNextQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    func didReciveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
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
    //MARK: Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
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
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            
            guard let self = self else { return }
            correctAnswers = 0
            currentQuestionIndex = 0
            questionFactory?.requestNextQuestion()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let game = GameResult(correct: correctAnswers, total: 10, date: Date())
            statisticService.store(gameResult: game)
            let text = "Ваш результат: \(correctAnswers)/10\n Колличество сыграннхы квизов \(statisticService.gamesCount)\n Рекорд \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз"
            )
            show(result: result)
            print("rigtn answers: \(statisticService.totalCorrectAnswer)/n Total questions: \(statisticService.totalQuestionsAsked)")
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
