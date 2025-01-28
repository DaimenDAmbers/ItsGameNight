//
//  SelectModeViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/22/24.
//

import UIKit

class SelectModeViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "SelectModeViewController"
    weak var delegate: MessageDelegate?
    
    // MARK: IB Outlets
    @IBOutlet weak var oneQuestionButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    
    override func viewDidLoad() {
        oneQuestionButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
        quizButton.applyShadow(cornerRadius: 5, interfaceStyle: traitCollection.userInterfaceStyle)
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        
        switch sender {
        case oneQuestionButton:
            presentOneQuestionVC()
        case quizButton:
            presentQuizVC()
        default:
            break
        }
    }
    
    // MARK: Private functions
    
    /// Present the View Controller for the `Select a Question` VC
    private func presentOneQuestionVC() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CategoryViewController.storyboardIdentifier) as? CategoryViewController else {
            fatalError("Unable to instantiate a ViewController from the storyboard")
        }
        
        controller.navigationItem.title = "Select a Difficulty and Category"
        controller.delegate = self.delegate
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
    
    /// Present the View Controller for the `Create a Quiz` VC.
    private func presentQuizVC() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CreateAQuizViewController.storyboardIdentifier) as? CreateAQuizViewController else {
            fatalError("Unable to instantiate a ViewController from the storyboard")
        }
        
        controller.navigationItem.title = "Create a Quiz"
//        controller.delegate = self.delegate
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
}
