//
//  MainCoordinator.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import UIKit

final class MainCoordinator: Coordinator, HomeCoordinatorDelegate {
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        viewController.homeCoordinatorDelegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // Just using Coordinator for navigation purpose if want to go detail page or login screen back
    
    func login() {
//        let coordinator = LoginCoordinator(navigationController: navigationController)
//        childCoordinators.append(coordinator)
//        coordinator.start()
    }
}
