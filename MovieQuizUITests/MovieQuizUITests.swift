//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Ilman on 24.12.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
       
        app.terminate()
        app = nil
        
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        
        
        app.buttons["Yes"].tap()
        sleep(2)
        let secondPoster = app.images["Poster"]
        
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstImage = app.images["Poster"]
        let firstImageData = firstImage.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        app.buttons["No"].tap()
        sleep(9)
        
        let secondImage = app.images["Poster"]
        let secondImageData = secondImage.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstImageData, secondImageData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
 
    func testAlertPresenter() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        sleep(3)
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        sleep(3)
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
