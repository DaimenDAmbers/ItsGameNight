//
//  CategoryViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 12/14/24.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "CategoryViewController"
    var trivia: TriviaMessage?
    let defaults = Defaults()
    weak var delegate: MessageDelegate?
    let categories = TriviaAPIData.Category.allCases
    
    
    // MARK: IB Varibles
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    
    // MARK: Private Functions
    
    /// Present the View Controller for selecting a qustion from 3 random questions from the selected `Category` and `Difficulty`.
    /// - Parameters:
    ///   - category: The category that was selected for the question.
    ///   - difficulty: The difficulty that was selected for the question.
    private func presentSelectQuestionVC(category: TriviaAPIData.Category, difficulty: TriviaAPIData.Difficulty) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SelectQuestionViewController.storyboardIdentifier) as? SelectQuestionViewController else {
            fatalError("Unable to instantiate a ViewController from the storyboard")
        }
        
        controller.navigationItem.title = category.description
        controller.delegate = self.delegate
        controller.category = category
        controller.difficulty = difficulty
        
        let navVC = UINavigationController(rootViewController: controller)
        self.present(navVC, animated: true, completion: nil)
    }
    
    // MARK: IB Actions
    
    /// Difficulty selector for `Easy`, `Medium`, `Hard` and `Any` difficulty settings.
    @IBAction func tappedDifficultyControl(_ sender: UISegmentedControl) {
        difficultyControl.selectedSegmentIndex = sender.selectedSegmentIndex
    }
}

// MARK: - UI Table View Data Source
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TriviaAPIData.Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        cell.categoryText.text = categories[indexPath.row].description
        
        return cell
    }
}

// MARK: - UI Table View Delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let difficulty = TriviaAPIData.Difficulty.allCases[difficultyControl.selectedSegmentIndex]
        self.presentSelectQuestionVC(category: self.categories[indexPath.row], difficulty: difficulty)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 6
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}

