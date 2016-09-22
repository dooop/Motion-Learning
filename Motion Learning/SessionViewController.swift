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
    @IBOutlet weak var pushButton: UIButton!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    override func viewDidLoad() {
        activityIndicator.alpha = 0
    }
    
    func analyse(sequence: [CMDeviceMotion]) {
        DispatchQueue.global().async {
            let inputs = MotionDetector.shared.inputs(for: sequence)
            let type = MotionDetector.shared.detect(inputs: inputs)
            
            Log.shared.write(entry: "\(type?.rawValue.uppercased() ?? "NOTHING") detected")
        }
    }
    
    // MARK: - Button actions
    
    @IBAction func start(_ sender: UIButton) {
        activityIndicator.show()
        
        MotionRecorder.shared.startRecording(onSequenceRecorded: analyse)
        
        Log.shared.write(entry: "Start recording")
    }
    
    @IBAction func stop(_ sender: UIButton) {
        activityIndicator.hide()
        
        MotionRecorder.shared.stopRecording()
        
        Log.shared.write(entry: "Stop recording")
    }
    
    @IBAction func loadWeights(_ sender: UIButton) {
        let success = MotionDetector.shared.loadWeights()
        
        Log.shared.write(entry: "Loading weights \(success ? "succeeded" : "failed")")
    }
    
    @IBAction func add(_ sender: UIButton) {
        let motionType: MotionType?
        
        switch sender {
        case standButton:
            motionType = .standing
        case walkButton:
            motionType = .walking
        case pushButton:
            motionType = .pushing
        default:
            motionType = nil
        }
        
        guard let sequence = MotionRecorder.shared.sequences.last, let type = motionType else {
            return
        }
        
        let inputs = MotionDetector.shared.inputs(for: sequence)
        let totalCalculatedError = MotionDetector.shared.add(inputs: inputs, for: type)
        
        Log.shared.write(entry: "Add \(inputs.count) inputs for \(type.rawValue.uppercased()) with total calculated error \(totalCalculatedError)")
    }
}
