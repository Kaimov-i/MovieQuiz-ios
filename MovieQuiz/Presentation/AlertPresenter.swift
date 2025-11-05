//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ilman on 03.11.2025.
//

import UIKit

class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.comlition()
        }
        
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }

}
