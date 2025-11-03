//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Ilman on 03.11.2025.
//

import Foundation

protocol AlertPresenterProtocol {
    func alertPresent(title: String, message: String, buttonText: String, complition: () -> Void) 
}
