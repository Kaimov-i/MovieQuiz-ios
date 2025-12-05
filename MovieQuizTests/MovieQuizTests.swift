//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Ilman on 05.12.2025.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        num1 + num2
    }
    
    func subtracttion(num1: Int, num2: Int) -> Int {
        num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        num1 * num2
    }
}

class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        //Give
        let arethmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        
        let result = arethmeticOperations.addition(num1: 1, num2: 3)
        
        //Then
        XCTAssertEqual(result, 3)
    }
}
