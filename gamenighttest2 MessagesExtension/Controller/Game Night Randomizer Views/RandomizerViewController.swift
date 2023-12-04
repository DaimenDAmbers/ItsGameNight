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
    let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan, .brown, .systemMint, .magenta, .systemIndigo, .systemTeal]

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var triangleView: TriangleView!
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
    }
    
    @IBAction func spinWheel(_ sender: UIButton) {
        pieChartView.rotatePieChart()
//        let time = dispatch_after(DISPATCH_TIME_NOW, dispatch_get_current_queue()) {
//            self.showSelectedPerson(from: <#T##[Person]#>)
//        }
    }
    
    private func showSelectedPerson(from people: [Person]) {
        for person in people {
            if person.isSelected {
                let label = "\(person.name) is the winner!"
                randomPersonLabel.text = label
            }
        }
    }
}
