//
//  Coordinator.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
