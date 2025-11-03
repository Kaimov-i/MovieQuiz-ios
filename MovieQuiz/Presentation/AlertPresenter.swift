//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilman on 03.11.2025.
//

import Foundation

class AlertPresenter: AlertPresenterProtocol {
    func alertPresent(title: String, message: String, buttonText: String, complition: () -> Void) {
        complition()
    }
    
    
}
