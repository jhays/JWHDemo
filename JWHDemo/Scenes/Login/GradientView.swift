//
//  GradientView.swift
//  gradientmaker
//
//  Created by Julian Hays on 3/7/15.
//  Copyright (c) 2015 orbosphere. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable class GradientView : UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.blue {
        didSet {
            configureView()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            configureView()
        }
    }
    @IBInspectable var gradientType: String = "Linear" {
        didSet {
            configureView()
        }
    }
    @IBInspectable var startX: CGFloat = 1.0 {
        didSet {
            configureView()
        }
    }
    @IBInspectable var startY: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    @IBInspectable var endX: CGFloat = 0.5 {
        didSet {
            configureView()
        }
    }
    @IBInspectable var endY: CGFloat = 0.0 {
        didSet {
            configureView()
        }
    }
    @IBInspectable var gradientAlpha: CGFloat = 1.0 {
        didSet {
            configureView()
        }
    }
    
    override class var layerClass: AnyClass {
      return CAGradientLayer.self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView(){
      //from IB
      let color1 = topColor
      let color2 = bottomColor
      let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
  
      if (gradientType == "Linear") {
        let layer = self.layer as! CAGradientLayer
        layer.colors = colors

        layer.startPoint = CGPoint(x:startX, y:startY)
        layer.endPoint = CGPoint(x:endX, y:endY)
        
      }else if(gradientType == "Radial"){
      
        let locations : [(CGFloat)] = [0.0, 1.0]
      
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)
        let myColorspace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let arrayRef : CFArray = colors as CFArray
        let myGradient : CGGradient = CGGradient(colorsSpace: myColorspace, colors: arrayRef, locations: locations)!
        
        let centerPoint : CGPoint = CGPoint(x:0.5 * bounds.size.width, y:0.5 * bounds.size.height)
        let myRadius : CGFloat = CGFloat(min(bounds.size.width, bounds.size.height)) * 1.0
      
        UIGraphicsGetCurrentContext()!.drawRadialGradient(myGradient, startCenter: centerPoint, startRadius: 0, endCenter: center, endRadius: myRadius, options: CGGradientDrawingOptions(rawValue: UInt32(3)))
          
      }
    }
}
