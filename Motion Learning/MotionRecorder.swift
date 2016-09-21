//
//  MotionRecorder.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 21.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation
import CoreMotion

class MotionRecorder {
    
    static let shared = MotionRecorder()
    
    private let manager = CMMotionManager()
    
    private let updatesPerSecond: Double = 50.0
    private let sequenceDuration: TimeInterval = 3.0
    private let sequenceLength: Int
    
    private var record: [CMDeviceMotion] = []
    private(set) var sequences: [[CMDeviceMotion]] = []
    
    var sequenceRecorded: (([CMDeviceMotion]) -> Void)?
    
    init() {
        sequenceLength = Int(updatesPerSecond * sequenceDuration)
        manager.deviceMotionUpdateInterval = 1 / updatesPerSecond
    }
    
    func startRecording() {
        guard manager.isDeviceMotionAvailable else {
            return
        }
        
        record.removeAll()
        sequences.removeAll()
        
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            guard let motion = motion else {
                return
            }
            
            self.record.append(motion)
            
            if self.record.count >= self.sequenceLength {
                self.sequences.append(self.record)
                self.sequenceRecorded?(self.record)
                self.record.removeAll()
            }
        }
    }
    
    func stopRecording() {
        manager.stopDeviceMotionUpdates()
    }
}
