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
    
    private let sequenceCount: Int
    private let sequenceDuration: TimeInterval = 1.0
    private let updatesPerSecond: Double = 50.0
    
    private(set) var sequences: [[CMDeviceMotion]] = []
    private var record: [CMDeviceMotion] = []
    
    init() {
        sequenceCount = Int(updatesPerSecond * sequenceDuration)
        manager.deviceMotionUpdateInterval = 1 / updatesPerSecond
    }
    
    func startRecording(onSequenceRecorded: @escaping ([CMDeviceMotion]) -> Void) {
        guard manager.isDeviceMotionAvailable else {
            return
        }
        
        record.removeAll()
        sequences.removeAll()
        
        manager.startDeviceMotionUpdates(to: OperationQueue()) { (motion, error) in
            guard let motion = motion else {
                return
            }
            
            self.record.append(motion)
            
            if self.record.count >= self.sequenceCount {
                self.sequences.append(self.record)
                onSequenceRecorded(self.record)
                self.record.removeAll()
            }
        }
    }
    
    func stopRecording() {
        manager.stopDeviceMotionUpdates()
    }
}
