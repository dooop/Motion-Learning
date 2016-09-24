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
        train(.standing)
    }
    
    @IBAction func walk(_ sender: UIButton) {
        train(.walking)
    }
    
    @IBAction func push(_ sender: UIButton) {
        train(.pushing)
    }
        
    func train(_ type: MotionType) {
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
