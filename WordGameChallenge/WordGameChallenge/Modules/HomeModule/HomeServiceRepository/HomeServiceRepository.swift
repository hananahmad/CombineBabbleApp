//
//  HomeServiceRepository.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import Foundation
import Combine

protocol HomeServiceType {
    func getAllWordPairs() -> AnyPublisher<[WordsDO], Error>
}

class HomeService: HomeServiceType {
    
    func getAllWordPairs() -> AnyPublisher<[WordsDO], Error> {
        return Bundle.main.readFile(file: "words.json")
            .mapError { error in
                return error
            }
            .decode(type: [WordsDO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
}
