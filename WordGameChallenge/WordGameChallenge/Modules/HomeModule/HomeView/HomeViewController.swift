//
//  HomeViewController.swift
//  WordGameChallenge
//
//  Created by Hanan Ahmed on 9/22/22.
//

import UIKit
import Combine

public protocol HomeCoordinatorDelegate: AnyObject {
    func login()
}

class HomeViewController: UIViewController {
    
    // MARK: -- Outlets
    @IBOutlet weak var correctAttemptsCountLabel: UILabel!
    
    @IBOutlet weak var englishTextLabel: UILabel!
    
    @IBOutlet weak var incorrectAttemptsCountLabel: UILabel!
    
    @IBOutlet weak var spanishTextLabel: UILabel!
    
    @IBOutlet weak var correctButton: UIButton!
    
    @IBOutlet weak var incorrectButton: UIButton!
    
    
    // MARK: -- Variables
    public weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
    
    private let vm = HomeViewModel()
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var countForCorrect = 0
    private var countForIncorrect = 0

    // MARK: -- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                    
                case .fetchWordDidSucceed(let word):
                    self?.updateWordPairContent(word)
                    
                case .fetchWordDidFail(let error):
                    self?.englishTextLabel.text = error.localizedDescription
                    self?.spanishTextLabel.text = ""
                    
                case .toggleButton(let isEnabled):
                    self?.correctButton.isEnabled = isEnabled
                    self?.incorrectButton.isEnabled = isEnabled
                    
                case .selectedWordDidSucceed(word: let word):
                    self?.updateWordPairContent(word)
                    self?.updateResultedCount(for: true)
                    
                case .selectedWordDidFail(word: let word):
                    self?.updateWordPairContent(word)
                    self?.updateResultedCount(for: false)
                    
                case .gameFinish:
                    self?.gameFinishPopup()
                }
            }.store(in: &cancellables)
        
    }
    
    private func updateWordPairContent(_ word: WordsDO) {
        self.englishTextLabel.text = word.englishText
        self.spanishTextLabel.text = word.spanishText
        
        animateSpanishLabel()
    }
    
    private func updateResultedCount(for correct: Bool) {
        if correct {
            countForCorrect += 1
            self.correctAttemptsCountLabel.text = "\(countForCorrect)"
        } else {
            countForIncorrect += 1
            self.incorrectAttemptsCountLabel.text = "\(countForIncorrect)"
        }
    }
    
    fileprivate func animateSpanishLabel() {
        UIView.transition(with: self.spanishTextLabel, duration: 1.0, options:
                            [.curveEaseOut, .transitionFlipFromTop], animations: {
        }, completion: {_ in
            
        })
    }
    
    private func gameFinishPopup() {
        let alert = UIAlertController(title: "Hey Sorry!", message: "Your game has been finished. Do you want to try your luck again?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Restart", style: UIAlertAction.Style.default, handler: { action in
            self.incorrectAttemptsCountLabel.text = "\(0)"
            self.correctAttemptsCountLabel.text = "\(0)"
            self.input.send(.viewDidAppear)
//            exit(0) // Kill app function
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: -- IBActions
private extension HomeViewController {
    
    @IBAction func correctBtnAction(_ sender: Any) {
        input.send(.correctButtonDidTap)
    }
    
    @IBAction func incorrectBtnAction(_ sender: Any) {
        input.send(.incorrectButtonDidTap)
    }
}
