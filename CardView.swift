//
//  CardView.swift
//  Timo
//
//  Created by Ha on 7/24/17.
//  Copyright © 2017 Ha. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBInspectable var cornerRadius : CGFloat = 8
    
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    
    @IBInspectable var shadowOffSetHeight : CGFloat = 2
    
    @IBInspectable var shadowColor : UIColor = UIColor.black
    
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        
        layer.shadowColor = shadowColor.cgColor
        
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
    
}
