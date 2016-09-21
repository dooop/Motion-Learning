//
//  MotionRecognizer.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 21.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation
import CoreMotion

class MotionRecognizer {
    
    static let shared = MotionRecognizer()
    
    func startSession() {
        MotionRecorder.shared.sequenceRecorded = detect
        MotionRecorder.shared.startRecording()
    }
    
    func stopSession() {
        MotionRecorder.shared.stopRecording()
    }
    
    func train() {
        // TODO
    }
    
    private func detect(sequence: [CMDeviceMotion]) {
        Log.shared.write(entry: "SEQUENCE COUNT: \(sequence.count)")
    }
}
