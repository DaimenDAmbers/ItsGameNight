//
//  RandomizerViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 11/22/23.
//

import UIKit

class RandomizerViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "RandomizerViewController"
    weak var delegate: MessageDelegate?
    var randomizer: Randomizer?
    let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan, .brown, .systemPink, .systemTeal, .systemMint,  .magenta, .systemIndigo]

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var randomPersonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedRandomizer = randomizer else { fatalError("No Randomized Message.") }

        let people = unwrappedRandomizer.people
        showSelectedPerson(from: people)

        for i in 0..<people.count {
            let segment = Segment(name: people[i].name, color: colors[i % colors.count], isSelected: people[i].isSelected)
            pieChartView.segments.append(segment)
        }
        
        pieChartView.backgroundColor = UIColor.clear
        view.addSubview(pieChartView)
    }
    
    @IBAction func spinWheel(_ sender: UIButton) {
        pieChartView.rotatePieChart()
    }
    
    private func showSelectedPerson(from people: [Person]) {
        for person in people {
            
            print("The isSelected value for \(person.name) was set to \(person.isSelected)")
            if person.isSelected {
                let label = "\(person.name) is the winner!"
                randomPersonLabel.text = label
            }
        }
    }
    
}
