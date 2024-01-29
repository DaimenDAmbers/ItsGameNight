//
//  PollViewController.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 1/10/24.
//

import UIKit

class RateATopicViewController: UIViewController {
    static let storyboardIdentifier = "RateATopicViewController"
    var poll: Poll?
    weak var delegate: MessageDelegate?
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var questionTextView: UITextView!
    let maxTextLength: Int = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
        questionTextView.delegate = self
        questionTextView.returnKeyType = .done
//        questionTextView.backgroundColor = UIColor(red: 228, green: 231, blue: 215, alpha: 1)
        questionTextView.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        questionTextView.text = "Enter a question..."
        questionTextView.textColor = .lightGray
        
        sendButton.isEnabled = false
        characterCountLabel.text = String(maxTextLength)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let question = questionTextView.text else { return }
        let questionImage = questionTextView.image()
        let backgroundImage = UIImage(named: "It's Game Night") ?? UIImage(named: "‎It's Game Night")!

        var size = CGSize(width: questionImage!.size.width, height: 300)
        UIGraphicsBeginImageContext(size)

        let newImage = backgroundImage.createMessageImage(titleImage: questionImage!)
//        let newImage = questionImage!.mergeWith(topImage: backgroundImage)
//        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
//        let image = renderer.image { ctx in
//            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        }
        poll = Poll(question: question, votes: [VotingDecisions.didNotVote: 0], image: newImage)
        delegate?.sendMessage(using: poll)
    }
}

// MARK: - Extensions
extension RateATopicViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let currentString = (textView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        
        if newString.count == 0 {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        let numLabel = String(maxTextLength - newString.count)
        characterCountLabel.text = numLabel
        
        return newString.count <= maxTextLength
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a question..."
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: UIView Extension
extension UIView {

    /// Creates an image from the view's contents, using its layer.
    ///
    /// - Returns: An image, or nil if an image couldn't be created.
    func image(with size: CGSize? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size ?? bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }

}

// MARK: UIImage Extensions
extension UIImage {
    
    class func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage? {
        
        let newImageWidth  = max(firstImage.size.width,  secondImage.size.width )
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width : newImageWidth, height: newImageHeight)
        
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        
        let firstImageDrawX  = round((newImageSize.width  - firstImage.size.width  ) / 2)
        let firstImageDrawY  = round((newImageSize.height - firstImage.size.height ) / 2)
        
        let secondImageDrawX = round((newImageSize.width  - secondImage.size.width ) / 2)
        let secondImageDrawY = round((newImageSize.height - secondImage.size.height) / 2)
        
        firstImage .draw(at: CGPoint(x: firstImageDrawX,  y: firstImageDrawY))
        secondImage.draw(at: CGPoint(x: secondImageDrawX, y: secondImageDrawY))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return image
    }
}

extension UIImage {

    func mergeImage(with secondImage: UIImage, point: CGPoint? = nil) -> UIImage {

        let firstImage = self
        let newImageWidth = max(firstImage.size.width, secondImage.size.width)
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)

        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)

        let firstImagePoint = CGPoint(x: round((newImageSize.width - firstImage.size.width) / 2),
                                      y: round((newImageSize.height - firstImage.size.height) / 2))

        let secondImagePoint = point ?? CGPoint(x: round((newImageSize.width - secondImage.size.width) / 2),
                                                y: round((newImageSize.height - secondImage.size.height) / 2))

        firstImage.draw(at: firstImagePoint)
        secondImage.draw(at: secondImagePoint)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image ?? self
    }
}

extension UIImage {
  func mergeWith(topImage: UIImage) -> UIImage {
    let bottomImage = self

    UIGraphicsBeginImageContext(size)


    let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
    bottomImage.draw(in: areaSize)

    topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

    let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return mergedImage
  }
}

extension UIImage {
    func createMessageImage(size: CGSize? = nil, titleImage: UIImage) -> UIImage {
        let backgroundImage = self
        var size = size ?? CGSize(width: 300, height: 300)
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage.draw(in: areaSize)

        titleImage.draw(in: CGRect(x: 0, y: 0, width: titleImage.size.width, height: titleImage.size.height))

        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
