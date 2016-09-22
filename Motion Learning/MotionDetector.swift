//
//  MotionRecognizer.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 21.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation
import CoreMotion

class MotionDetector {
    
    static let shared = MotionDetector()
    
    func train() {
        // TODO
    }
    
    func detect(sequence: [CMDeviceMotion]) {
        Log.shared.write(entry: "SEQUENCE COUNT: \(sequence.count)")
    }
}
