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

    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat {
        let segments = Segment.numOfSegments
        return CGFloat(360 / segments)
    }
    
    static var numOfSegments: Int = 0
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            
            // The text label (adjust as needed)
            let label = segment.name
            
            
            // Calculate the bounding box and adjust for the center location
            var rect = label.boundingRect(with: CGSize(width: 1000, height: 1000), attributes: textAttrs, context: nil)
            rect.origin.x = textCenter.x - rect.size.width / 2
            rect.origin.y = textCenter.y - rect.size.height / 2
            
//            ctx?.saveGState()
//            ctx?.rotate(by: endAngle)
            
            label.draw(in: rect, withAttributes: textAttrs)
            
            UIGraphicsPopContext()
            
//            ctx?.restoreGState()
            

            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
            
    }
    
    func rotatePieChart() {
        let rotations: Double = 5
        let duration: Double = 3.0
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = CGFloat(.pi/2 * rotations * duration)
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = false
        rotationAnimation.repeatCount = 1
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
        
        self.layer.add(rotationAnimation, forKey: "transform.rotation")
    }
}


