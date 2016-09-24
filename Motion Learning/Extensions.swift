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
