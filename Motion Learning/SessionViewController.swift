//
//  SessionViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 19.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit
import CoreMotion

class SessionViewController: UIViewController {
    
    private var animationViewController: AnimationViewController?
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "animationViewController" {
            animationViewController = sender as? AnimationViewController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MotionRecorder.shared.startRecording(onSequenceRecorded: analyse)
        
        Log.shared.write(entry: "Start recording")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MotionRecorder.shared.stopRecording()
        
        Log.shared.write(entry: "Stop recording")
    }
    
    func analyse(sequence: [CMDeviceMotion]) {
        DispatchQueue.global().async {
            let inputs = MotionDetector.shared.inputs(for: sequence)
            let type = MotionDetector.shared.detect(inputs: inputs)
            
            Log.shared.write(entry: "\(type?.rawValue.uppercased() ?? "NOTHING") detected")
        }
    }
}
