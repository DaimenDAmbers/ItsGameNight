//
//  PieWheel.swift
//  It's Game Night App MessagesExtension
//
//  Created by Daimen Ambers on 11/26/23.
//

import UIKit

class Segment {

    // the color of a given segment
    var color: UIColor
    
    // name of the segment
    var name: String
    
    // selected segment
    var isSelected: Bool

    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat {
        let segments = Segment.numOfSegments
        return CGFloat(360 / segments)
    }
    
    static var numOfSegments: Int = 0
    
    init(name: String, color: UIColor, isSelected: Bool) {
        self.name = name
        self.color = color
        self.isSelected = isSelected
        Segment.numOfSegments += 1
    }
    
    deinit {
        Segment.numOfSegments -= 1
    }
}

class PieChartView: UIView {

    /// An array of structs representing the segments of the pie chart
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }
    
    /// Used to stop the pie wheel at the selected name
    var selectedSegmentPoint: CGFloat = 0
    
    /// Will be used to offset where the needle lands on the selected name
    var shiftPoint: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        // get current context
        let ctx = UIGraphicsGetCurrentContext()

        // radius is the half the frame's width or height (whichever is smallest)
        let radius = min(frame.size.width, frame.size.height) * 0.5

        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)

        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})

        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5
        
        // Attributes for the labels. Adjust as desired
        let textAttrs: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: UIColor.black,
        ]
        
        for segment in segments { // loop through the values array
            UIGraphicsBeginImageContext(CGSize.init(width: bounds.size.width * 0.5, height: bounds.size.height * 0.5))

            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)

            // update the end angle of the segment
            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)

            // move to the center of the pie chart
            ctx?.move(to: viewCenter)

            // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

            // fill segment
            ctx?.fillPath()
            
            // adding text to the pie slice
            UIGraphicsPushContext(ctx!)
            
            // Calculate center location of label
            // Replace the 0.75 with a desired distance from the center
            let midAngle = (startAngle + endAngle) / 2
            let textCenter = CGPoint(x: cos(midAngle) * radius * 0.60 + viewCenter.x, y: sin(midAngle) * radius * 0.60 + viewCenter.y)
            
            if segment.isSelected {
                selectedSegmentPoint = midAngle
//                shiftPoint = midAngle // Will use this for making the selection seem random.
//                print("Shifted point: \(shiftPoint)")
            }
            
            // The text label (adjust as needed)
            let label = segment.name
            
            // Calculate the bounding box and adjust for the center location
            var rect = label.boundingRect(with: CGSize(width: 1000, height: 1000), attributes: textAttrs, context: nil)
//            rect = rotateRect(rect)
            rect.origin.x = textCenter.x - rect.size.width / 2
            rect.origin.y = textCenter.y - rect.size.height / 2
  
            label.draw(in: rect, withAttributes: textAttrs)

            //TODO: Find out how to rotate the text in it's pie slice
            
            UIGraphicsEndImageContext()
            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
            
    }
    
    /// Use this to rotate the pie chart to the selected slice
    func rotatePieChart() {
        var quadrant = Quadrants.one
        quadrant = quadrant.checkQuadrant(value: selectedSegmentPoint)
        
        let actualValue = 2 * quadrant.rawValue - selectedSegmentPoint
//        let value = shiftRotation(valueToShift: actualValue)
        let rotationAnimation = rotationAnimation(numOfRotations: 7, duration: 7, rotateTo: actualValue)
        
        self.layer.add(rotationAnimation, forKey: "transform.rotation")
    }
    
    /// This is used to calculate the `rotateToValue`
    /// - Parameters:
    ///   - numOfRotations: The number of rotations that the pie chart will make
    ///   - duration: Time the pie chart will rotate for in seconds
    ///   - rotateTo: The calculated value to rotate to the correct slice using 2 * quardrant value - the selected segment
    /// - Returns: This function returns a `CABasicAnimation`
    private func rotationAnimation(numOfRotations: Double, duration: Double, rotateTo: CGFloat) -> CABasicAnimation {
        let oneRotation: Double = 2 * .pi
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = rotateTo + (numOfRotations * oneRotation)
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = false
        rotationAnimation.repeatCount = 1
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
        
        return rotationAnimation
    }
    
    
    /// Shifts the rotation a little bit to simulate a randomized spin
    private func shiftRotation(valueToShift: Double) -> Double {
       let value = valueToShift + shiftPoint
        
        return value
    }
    
    private func rotateRect(_ rect: CGRect) -> CGRect {
        let x = rect.midX
        let y = rect.midY
//        let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi/2).translatedBy(x: -x, y: -y)
        let transform2 = CGAffineTransformRotate(CGAffineTransform(translationX: x, y: y), .pi/2).translatedBy(x: -x, y: -y)
        
        return rect.applying(transform2)
    }
    
    private func rotateRect(context ctx: CGContext?) {
        ctx?.saveGState()
        ctx?.concatenate(CGAffineTransformMakeTranslation(0, 0))
        ctx?.concatenate(CGAffineTransformMakeRotation(.pi))

        
        
//            ctx?.translateBy(x: 10, y: 20)
//            ctx?.rotate(by: -0.4636)
        
//            rect = rect.applying(CGAffineTransform(rotationAngle: 0.2))
        
//        label.draw(in: rect, withAttributes: textAttrs)
        
        ctx?.concatenate(CGAffineTransformInvert(CGAffineTransformMakeTranslation(0, 0)))
        ctx?.concatenate(CGAffineTransformInvert(CGAffineTransformMakeRotation(.pi)))
        
        
//            UIGraphicsPopContext()
        
        ctx?.restoreGState()
    }
}

/// Used to find the quadrants of the pie wheel
enum Quadrants: Double {
    case one, two, three, four
    
    var rawValue: Double {
        switch self {
        case .one:
            return 0
        case .two:
            return .pi
        case .three:
            return 3 * .pi/2
        case .four:
            return 2 * .pi
        }
    }
    
    /// Check which quadrand the `selectedSegmentPoint` lands on
    /// - Parameter value: The value of the `selectedSegmentPoint`
    /// - Returns: The quadrant that the `value` falls in.
    func checkQuadrant(value: Double) -> Quadrants {
        if value > Quadrants.one.rawValue && value < Quadrants.two.rawValue {
            return Quadrants.one
        } else if value > Quadrants.two.rawValue && value < Quadrants.three.rawValue {
            return Quadrants.two
        } else if value > Quadrants.three.rawValue && value < Quadrants.four.rawValue {
            return Quadrants.three
        } else {
            return Quadrants.four
        }
    }
}
