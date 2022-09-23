//
//  Decodable+FromJSON.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import UIKit
import Combine


extension Bundle{
    func readFile(file: String) -> AnyPublisher<Data, Error> {
        self.url(forResource: file, withExtension: nil)
            .publisher
            .tryMap{ string in
                guard let data = try? Data(contentsOf: string) else {
                    fatalError("Failed to load \(file) from bundle.")
                }
                return data
            }
            .mapError { error in
                return error
            }.eraseToAnyPublisher()
    }
    
    
}
