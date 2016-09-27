//
//  TrainingViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 19.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class TrainingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func stand(_ sender: UIButton) {
        sender.isEnabled = false
        train(.standing, with: {
            sender.isEnabled = true
        })
    }
    
    @IBAction func walk(_ sender: UIButton) {
        sender.isEnabled = false
        train(.walking, with: {
            sender.isEnabled = true
        })
    }
    
    @IBAction func push(_ sender: UIButton) {
        sender.isEnabled = false
        train(.pushing, with: {
            sender.isEnabled = true
        })
    }
        
    func train(_ type: MotionType, with completion: @escaping () -> Void) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
        
        self.recordMotionSequence(after: .now() + 3) { sequence in
            DispatchQueue.global().async {
                let inputs = MotionDetector.shared.inputs(for: sequence)
                let totalCalculatedError = MotionDetector.shared.train(inputs: inputs, for: type)
                
                DispatchQueue.main.async {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    
                    Log.shared.write(entry: "Train \(type.rawValue.uppercased())\nError: \(totalCalculatedError ?? 0)\nInputs: \(inputs)\n")
                    completion()
                }
            }
        }
    }
    
    func recordMotionSequence(after delay: DispatchTime, with completion: @escaping ([CMDeviceMotion]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            MotionRecorder.shared.startRecording(onSequenceRecorded: { sequence in
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                MotionRecorder.shared.stopRecording()
                
                completion(sequence)
            })
        }
    }
}
