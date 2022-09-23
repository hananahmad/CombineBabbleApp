//
//  WordsDO.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import Foundation

struct WordsDO: Decodable {
  let spanishText: String?
  let englishText: String?
    
    enum CodingKeys: String, CodingKey {
        case spanishText = "text_spa"
        case englishText = "text_eng"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spanishText = try container.decodeIfPresent(String.self, forKey: .spanishText)
        self.englishText = try container.decodeIfPresent(String.self, forKey: .englishText)
    }
}
