//
//  Extensions.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 20.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func show() {
        UIView.animate(withDuration: 0.42) { 
            self.alpha = 1.0
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.42) {
            self.alpha = 0.0
        }
    }
}

extension Float {
    var format: String {
        return String(format: "%.5f", self)
    }
}

extension CALayer {
    func fade(to opacity: CGFloat) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = self.opacity
        animation.toValue = opacity
        animation.duration = 0.42
        animation.repeatCount = 0
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        self.add(animation, forKey: "opacity")
    }
}
