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

    @IBOutlet weak var randomPersonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedRandomizer = randomizer else { fatalError("No Randomized Message.") }

        let people = unwrappedRandomizer.people
        for person in people {
            
            print("The isSelected value for \(person.name) was set to \(person.isSelected)")
            if person.isSelected {
                let label = "\(person.name) is the winner!"
                randomPersonLabel.text = label
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
