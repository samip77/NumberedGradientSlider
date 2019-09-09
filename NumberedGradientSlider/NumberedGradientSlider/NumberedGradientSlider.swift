//
//  NumberedGradientSlider.swift
//  NumberedGradientSlider
//
//  Created by Samip on 9/9/19.
//  Copyright © 2019 Samip. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NumberedGradientSlider: UISlider {
    
    //MARK:-Variables
    @IBInspectable
    private var textColor:UIColor?
    @IBInspectable
    private var font:UIFont?
    private var thumbLabel:UILabel?
    
    private var gradientColors:[UIColor] = [UIColor.blue,UIColor.blue.withAlphaComponent(0.5) ,UIColor.green]
     @IBInspectable
    private var gradientStartPoint: CGPoint = CGPoint(x: 0.0, y:  1.0)
     @IBInspectable
    private var gradientEndPoint:CGPoint = CGPoint(x: 1.0, y:  1.0);
    
    //MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    
    //Setup
    func setup(){
        textColor = UIColor.white
        self.thumbTintColor = .purple
        font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    func thumbLayoutSetup(){
        thumbLabel = UILabel(frame: CGRect.zero)
        thumbLabel?.isUserInteractionEnabled = false
        thumbLabel?.text = "";
        thumbLabel?.textAlignment = .center
        thumbLabel?.numberOfLines = 1
        thumbLabel?.allowsDefaultTighteningForTruncation = true
        thumbLabel?.textColor = self.textColor
        thumbLabel?.backgroundColor = .clear
        self.superview?.addSubview(thumbLabel!)
        updateThumbLabel()
    }
    
    func trackLayoutSetup(){
        
        let layer = CAGradientLayer()
        layer.frame = trackRect(forBounds: bounds)
        layer.colors = gradientColors.map({ $0.cgColor
        })
        layer.endPoint = self.gradientEndPoint
        layer.startPoint  = self.gradientStartPoint
        layer.cornerRadius = layer.frame.height/2
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setMaximumTrackImage(image?.resizableImage(withCapInsets:.zero),  for: .normal)
        self.setMinimumTrackImage(image?.resizableImage(withCapInsets:.zero),  for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard thumbLabel != nil else {
            thumbLayoutSetup()
            trackLayoutSetup()
            return
        }
        
    }
    
    func updateThumbLabel(){
        thumbLabel?.text = "\(self.value)"
        thumbLabel?.font = self.font
        
        let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: self.trackRect(forBounds: self.bounds), value: self.value)
        let originX = thumbRect.origin.x + self.frame.origin.x
        let originY = self.frame.origin.y
    
        let width = thumbRect.width
        let height = self.frame.height
        
        thumbLabel?.frame = CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    
    //MARK:- UISlider Methods
    override func setValue(_ value: Float, animated: Bool) {
        super.setValue(value, animated: animated)
        self.updateThumbLabel()
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = 15
        return rect
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.updateThumbLabel()
        return super.beginTracking(touch, with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.updateThumbLabel()
        return super.continueTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        self.updateThumbLabel()
        super.cancelTracking(with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
    }
    
}
