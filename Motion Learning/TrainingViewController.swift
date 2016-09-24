//
//  TrainingViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 19.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit
import AVFoundation

class TrainingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func stand(_ sender: UIButton) {
        train(.standing)
    }
    
    @IBAction func walk(_ sender: UIButton) {
        train(.walking)
    }
    
    @IBAction func push(_ sender: UIButton) {
        train(.pushing)
    }
    
    func train(_ type: MotionType) {
        var recordingStarted = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
        
        MotionRecorder.shared.startRecording { sequence in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            if !recordingStarted {
                recordingStarted = true
                
                return
            }
            
            MotionRecorder.shared.stopRecording()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            
            DispatchQueue.global().async {
                let inputs = MotionDetector.shared.inputs(for: sequence)
                let totalCalculatedError = MotionDetector.shared.train(inputs: inputs, for: type)
                
                Log.shared.write(entry: "Add \(inputs.count) inputs for \(type.rawValue.uppercased()) with total calculated error \(totalCalculatedError ?? 0)")
            }
        }
    }
}
