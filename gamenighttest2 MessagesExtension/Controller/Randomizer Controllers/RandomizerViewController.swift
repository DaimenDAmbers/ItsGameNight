//
//  RandomizerViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 11/22/23.
//

import UIKit
import GoogleMobileAds

class RandomizerViewController: UIViewController {
    
    // MARK: Variables
    static let storyboardIdentifier = "RandomizerViewController"
    weak var delegate: MessageDelegate?
    var randomizer: Randomizer?
    let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan, .brown, .systemMint, .magenta, .systemIndigo, .systemTeal]

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var triangleView: TriangleView!
    @IBOutlet weak var randomPersonLabel: UILabel!
    @IBOutlet weak var spinButton: UIButton!
    
    // MARK: Google Banner Ad
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedRandomizer = randomizer else { fatalError("No Randomized Message.") }

        let people = unwrappedRandomizer.people

        for i in 0..<people.count {
            let segment = Segment(name: people[i].name, color: colors[i % colors.count], isSelected: people[i].isSelected)
            pieChartView.segments.append(segment)
        }
        
        randomPersonLabel.isHidden = true
        
        var googleAdsManager = GoogleAdsManager(controller: self)
        bannerView = googleAdsManager.createBannerAd()
        self.addBannerViewToView(bannerView)
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    @IBAction func spinWheel(_ sender: UIButton) {
        pieChartView.rotatePieChart()
        
        spinButton.isSelected.toggle()
        randomPersonLabel.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            guard let people = self.randomizer?.people else { fatalError() }
            self.showSelectedPerson(from: people)
            self.spinButton.setTitle("See animation again?", for: .selected)
        }
    }
    
    private func showSelectedPerson(from people: [Person]) {
        for person in people {
            if person.isSelected {
                let label = "\(person.name) is the winner!"
                randomPersonLabel.text = label
                randomPersonLabel.isHidden = false
            }
        }
    }
}
