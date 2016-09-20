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

extension UIActivityIndicatorView {
    override func show() {
        self.startAnimating()
        super.show()
    }
    
    override func hide() {
        super.hide()
        self.stopAnimating()
    }
}

extension Array {
    func splitBy(subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map { startIndex in
            let endIndex = startIndex.advanced(by: subSize)
            return Array(self[startIndex ..< endIndex])
        }
    }
}

extension String {
    func insert(string:String, index:Int) -> String {
        return  String(self.characters.prefix(index)) + string + String(self.characters.suffix(self.characters.count-index))
    }
}
