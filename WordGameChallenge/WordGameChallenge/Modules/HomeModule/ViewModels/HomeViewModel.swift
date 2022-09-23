//
//  HomeViewModel.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import Foundation
import Combine

class HomeViewModel {
    
    enum Input {
        case viewDidAppear
        case correctButtonDidTap
        case incorrectButtonDidTap
    }
    
    enum Output {
        case fetchWordDidFail(error: Error)
        case fetchWordDidSucceed(word: WordsDO)
        case selectedWordDidSucceed(word: WordsDO)
        case selectedWordDidFail(word: WordsDO)
        case toggleButton(isEnabled: Bool)
        case gameFinish
    }
    
    // MARK: -- Variables
    private let homeServiceType: HomeServiceType
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var wordsArray = [WordsDO]() // Use for storing random pairs
    var wordsPairDictionary = [String?: String?]() // Use for checking correct and not correct pairs
    var counter = 0
    var timer: Timer?
    var incorrectAnswersCount = 0

    // MARK: -- Initialization DI
    init(homeServiceType: HomeServiceType = HomeService()) {
        self.homeServiceType = homeServiceType
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear:
                self?.handleGetWordPairs()
            case .correctButtonDidTap:
                self?.handleGetNextRandomWordPair()
            case .incorrectButtonDidTap:
                self?.handleGetNextRandomWordPair()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    fileprivate func passTheNextWordPair() {
        // Checking 25 percent probability need some more concise
        if let nextWordPair = (counter % 25 == 0) ? getRandomWordPair(from: self.wordsArray) : self.wordsArray[safe: 0] {
            self.output.send(.fetchWordDidSucceed(word: nextWordPair))
            self.wordsArray.removeFirst()
        }
        
        // Quit app
        if self.wordsPairDictionary.count == self.wordsArray.count + 15 {
            self.invalidateTimer()
            print("Game End")
            output.send(.toggleButton(isEnabled: false))
            output.send(.gameFinish)
        }
    }
    
    // MARK: -- Get Word Pairs From JSON
    private func handleGetWordPairs() {
        
        counter = 0 // For initial stage
        incorrectAnswersCount = 0 // For initial stage
        
        checkIfRefreshNeededForNewPair()
        output.send(.toggleButton(isEnabled: false))
        
        homeServiceType.getAllWordPairs().sink { [weak self] completion in
            self?.output.send(.toggleButton(isEnabled: true))
            if case .failure(let error) = completion {
                self?.output.send(.fetchWordDidFail(error: error))
            }
        } receiveValue: { [weak self] words in
            self?.wordsArray = words
            self?.mapAllWordsPairToDict(wordsPairArray: words)
            self?.passTheNextWordPair()
            self?.wordsArray.removeFirst()
        }.store(in: &cancellables)
    }
    
    // MARK: -- Mapping Hashmap for quick search correct or incorrect word in O(1)
    private func mapAllWordsPairToDict(wordsPairArray: [WordsDO]) {
        for word in wordsPairArray {
            self.wordsPairDictionary.updateValue(word.spanishText, forKey: word.englishText)
        }
    }
    
    private func handleGetNextRandomWordPair() {
        if let currentWordPair = self.wordsArray[safe: 0] {
            handleStateOfAnswer(forWord: currentWordPair)
        }
        self.passTheNextWordPair()
    }
    
    
    // MARK: -- Get Random Pair
    fileprivate func getRandomWordPair(from words: [WordsDO]) -> WordsDO? {
        if let randomPair = words.randomElement() {
            return randomPair
        }
        
        return nil
    }
    
    // MARK: -- Handle State of answers
    private func handleStateOfAnswer(forWord word: WordsDO) {
        if word.spanishText == self.wordsPairDictionary[word.englishText] {
            self.output.send(.selectedWordDidSucceed(word: word))
        } else {
            incorrectAnswersCount += 1
            self.output.send(.selectedWordDidFail(word: word))
            gameQuitForIncorrectAnswers()
        }
    }
    
    // MARK: -- Timer for 5 second on every pair
    fileprivate func checkIfRefreshNeededForNewPair() {
        
        timer =  Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
            // Do what you need to do repeatedly
            if self.counter == self.wordsPairDictionary.count - 1 {
                self.invalidateTimer()
            }
            if let currentWordPair = self.wordsArray[safe: 0] {
                self.output.send(.selectedWordDidFail(word: currentWordPair))
            }
            
            self.incorrectAnswersCount += 1
            self.gameQuitForIncorrectAnswers() // Check and quit if three incorrect answers
            
            self.passTheNextWordPair()
            self.counter += 1
        }
    }
    
    // MARK: -- Invalidate Timer
    fileprivate func invalidateTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    fileprivate func gameQuitForIncorrectAnswers() {
        // Quit app
        if incorrectAnswersCount == 3 { // After 3 Incorrect attempts game end
            self.invalidateTimer()
            print("Game End")
            output.send(.toggleButton(isEnabled: false))
            output.send(.gameFinish)
        }
    }
}
