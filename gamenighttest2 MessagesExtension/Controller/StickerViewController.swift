//
//  StickerViewController.swift
//  gamenighttest2 MessagesExtension
//
//  Created by Daimen Ambers on 10/13/23.
//

import UIKit
import Messages

class StickerViewController: MSStickerBrowserViewController {
    static let storyboardIdentifier = "StickerViewController"
    var stickers = [MSSticker]()
    weak var delegate: MessageDelegate?
    
    override var stickerSize: MSStickerSize {
        return .large
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.changePresentationStyle(.expanded) // Needed to fix the bug where selecting a sticker does not dismiss the view controller.
        
        self.title = "Stickers"
        createSticker(asset: "Gamenight Logo", localizedDescription: "Game Night Logo")
        createSticker(asset: "It's Gamenight", localizedDescription: "It's Gamenight")
        createSticker(asset: "It's Intermission", localizedDescription: "It's Intermission")
        createSticker(asset: "1stPlace", localizedDescription: "1st Place")
        createSticker(asset: "2ndPlace", localizedDescription: "2nd Place")
        createSticker(asset: "3rdPlace", localizedDescription: "3rd Place")
        createSticker(asset: "YouTried", localizedDescription: "You Tried")
        createSticker(asset: "Did you tell them?", localizedDescription: "Did you tell them?")
        createSticker(asset: "Good Dinner", localizedDescription: "Good Dinner")
        createSticker(asset: "Bad Dinner", localizedDescription: "Bad Dinner")
        createSticker(asset: "Red Team", localizedDescription: "Red Team")
        createSticker(asset: "Blue Team", localizedDescription: "Blue Team")
        createSticker(asset: "idk timezones", localizedDescription: "I don't know timezones")
        createSticker(asset: "Get Outta Here", localizedDescription: "Get Outta Here")
        createSticker(asset: "Too Bad", localizedDescription: "Too Bad")
        createSticker(asset: "Nice Try", localizedDescription: "Nice Try")
        createSticker(asset: "Youre Welcome", localizedDescription: "You're Welcome")
        createSticker(asset: "Plus Six", localizedDescription: "Plus Six")
        createSticker(asset: "‎Let's Coast Logo", localizedDescription: "Let's Coast Logo")
    }
    
    /// Creates a MSSticker to use in the app
    /// - Parameters:
    ///   - asset: Name of the sticker
    ///   - localizedDescription: Description of the sticker
    private func createSticker(asset: String, localizedDescription: String){

        guard let stickerPath = Bundle.main.path(forResource:asset, ofType:"png") else {
          print("couldn't create the sticker path for", asset)
          return
        }

        // we use URL so, it's possible to use image from network
        let stickerURL = URL(fileURLWithPath:stickerPath)

        let sticker: MSSticker
        do {

          try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
          // localizedDescription for accessibility

          stickers.append(sticker)
        } catch {
          print(error)
          return
        }

      }
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int{
        return stickers.count
      }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker{

        return stickers[index] as MSSticker
      }
}
