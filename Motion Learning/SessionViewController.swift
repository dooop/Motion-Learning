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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        activityIndicator.alpha = 0
    }
    
    func analyse(sequence: [CMDeviceMotion]) {
        let type = MotionDetector.shared.detect(sequence: sequence)
        Log.shared.write(entry: "\(type?.rawValue.uppercased() ?? "NOTHING") detected")
    }
    
    // MARK: - Button actions
    
    @IBAction func start(_ sender: UIButton) {
        activityIndicator.show()
        
        MotionRecorder.shared.startRecording(onSequenceRecorded: analyse)
    }
    
    @IBAction func stop(_ sender: UIButton) {
        activityIndicator.hide()
        
        MotionRecorder.shared.stopRecording()
    }
    
    @IBAction func train(_ sender: UIButton) {
        activityIndicator.show()
        sender.isEnabled = false
        
        DispatchQueue.global().async {
            MotionDetector.shared.train()
            
            DispatchQueue.main.async {
                self.activityIndicator.hide()
                sender.isEnabled = true
            }
        }
    }
}
