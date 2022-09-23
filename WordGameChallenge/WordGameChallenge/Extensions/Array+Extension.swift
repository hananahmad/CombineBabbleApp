//
//  Array+Extension.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it exists, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


