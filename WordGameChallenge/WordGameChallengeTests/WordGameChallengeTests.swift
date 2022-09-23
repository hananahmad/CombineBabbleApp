//
//  WordGameChallengeTests.swift
//  WordGameChallengeTests
//
//  Created by Hanan Ahmed on 9/22/22.
//

import XCTest
import Combine

@testable import WordGameChallenge

final class WordGameChallengeTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
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
    
    func testJSONMapping() throws {
        let getWordsPairService : HomeServiceType? = HomeService()
        
        getWordsPairService?.getAllWordPairs().sink {  completion in
            if case .failure(let error) = completion {
                XCTFail("\(error.localizedDescription)")
            }
        } receiveValue: {  words in
            XCTAssertEqual(words.count, 297)

        }.store(in: &cancellables)
    }
    
    func testFirstPairMatchesWithJSON() throws {
        let getWordsPairService : HomeServiceType? = HomeService()
        
        getWordsPairService?.getAllWordPairs().sink {  completion in
            if case .failure(let error) = completion {
                XCTFail("\(error.localizedDescription)")
            }
        } receiveValue: {  words in
            XCTAssertEqual(words[0].englishText, "primary school")

        }.store(in: &cancellables)
    }
    
    func testCorrectPair() throws {
        let getWordsPairService : HomeServiceType? = HomeService()
        
        getWordsPairService?.getAllWordPairs().sink {  completion in
            if case .failure(let error) = completion {
                XCTFail("\(error.localizedDescription)")
            }
        } receiveValue: {  words in
            XCTAssertEqual(words[0].englishText, "primary school")
            XCTAssertEqual(words[0].spanishText, "escuela primaria")
            
        }.store(in: &cancellables)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
