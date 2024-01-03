//
//  MotiQTests.swift
//  MotiQTests
//
//  Created by Darie Nistor Nicolae on 26.11.2023.
//

import XCTest
@testable import MotiQ

final class MotiQTests: XCTestCase {
    var sut: CoreDataViewModel!
    
    override func setUpWithError() throws {
        sut = CoreDataViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
    func testAddQuoteToCoreData() {
        let quote = "I'm here"
        let author = "Me"
        
        let savedData: () = sut.addQuote(quote: quote, author: author)
        XCTAssertNoThrow(savedData, "doesn't throw")
        
    }
    
    func testIsNotSavedQuote() {
        let sut = MotivationalViewModel()
       
        XCTAssertFalse(sut.isSaved, "it is saved")
    }
    
    func testSavedQuote() {
        let sut = MotivationalViewModel()
        sut.toggleSaveQuote()
        XCTAssertTrue(sut.isSaved, "it is not saved")
    }
    
}
