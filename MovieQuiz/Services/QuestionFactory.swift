//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Ilman on 02.11.2025.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    
    private let moviesLoader: MovieLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MovieLoading, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(
    //            image: "The Godfather",
    //            text: "Рейтинг этого фильма больше чем 6?" ,
    //            currentAnswer: true),
    //        QuizQuestion(
    //            image: "The Dark Knight",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: true),
    //        QuizQuestion(
    //            image: "Kill Bill",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: true),
    //        QuizQuestion(
    //            image: "The Avengers",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: true),
    //        QuizQuestion(
    //            image: "Deadpool",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: true,),
    //        QuizQuestion(
    //            image: "The Green Knight",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: true),
    //        QuizQuestion(
    //            image: "Old",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: false),
    //        QuizQuestion(
    //            image: "The Ice Age Adventures of Buck Wild",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: false),
    //        QuizQuestion(
    //            image: "Tesla",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: false),
    //        QuizQuestion(
    //            image: "Vivarium",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            currentAnswer: false)
    //    ]
    //
    
    private var movies: [MostPopularMovie] = []
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                switch result {
                case .success(let movies):
                    self.movies = movies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
                print("Faled load image")
            }
            
            let raiting = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = raiting > 7
            let question = QuizQuestion(
                image: imageData,
                text: text,
                currentAnswer: correctAnswer
            )
            
            DispatchQueue.main.async { [weak self ] in
                guard let self = self else { return }
                self.delegate?.didReciveNextQuestion(question: question)
               
            }
        }
    }
    
    //    func requestNextQuestion() {
    //        guard let index = (0..<questions.count).randomElement() else {
    //            delegate?.didReciveNextQuestion(question: nil)
    //            return
    //        }
    //
    //        let question = questions[safe: index]
    //        delegate?.didReciveNextQuestion(question: question)
    //    }
}


