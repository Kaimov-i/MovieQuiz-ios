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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var questionFactory: QuestionFactoryProtocol?
   
    private var alertPresenter = AlertPresenter()
    var statisticService: StatisticServiceProtocol!
    private let presenter = MovieQuizPresenter()
    
    private var correctAnswers = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticService()
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    // MARK: - QuestionFactoryDelegate
    func didReciveNextQuestion(question: QuizQuestion?) {
        presenter.didReciveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkEror(message: error.localizedDescription)
        
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked(sender)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked(sender)
    }
    
    //MARK: Private functions
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        couterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool, isButtonActive: UIButton) {
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
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            imageView.layer.borderWidth = .nan
            isButtonActive.isEnabled = true
        }
    }
    
    func show(result: QuizResultsViewModel) {
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            
            guard let self = self else { return }
            correctAnswers = 0
            presenter.resetQuestionIndex()
            questionFactory?.requestNextQuestion()
        }
        alertPresenter.show(in: self, model: model)
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestionIndex() {
            let game = GameResult(correct: correctAnswers, total: 10, date: Date())
            statisticService.store(gameResult: game)
            let text = "Ваш результат: \(correctAnswers)/10\n Колличество сыграннхы квизов \(statisticService.gamesCount)\n Рекорд \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз"
            )
            show(result: result)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkEror(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Error",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        
        alertPresenter.show(in: self, model: alert)
    }
}
