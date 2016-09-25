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
    
    @IBOutlet weak var standingIcon: UIImageView!
    @IBOutlet weak var walkingIcon: UIImageView!
    @IBOutlet weak var pushingIcon: UIImageView!
    
    private var animationViewController: AnimationViewController?
    private var icons = [MotionType: UIImageView]()
    
    private var detectedMotion: MotionType? {
        didSet {
            animationViewController?.showAnimation(for: detectedMotion)
            icons.values.forEach({ $0.isHighlighted = false })
            
            if let type = detectedMotion {
                icons[type]?.isHighlighted = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "animationViewController" {
            animationViewController = segue.destination as? AnimationViewController
            animationViewController?.loadAnimations()
        }
    }
    
    override func viewDidLoad() {
        icons[.standing] = standingIcon
        icons[.walking] = walkingIcon
        icons[.pushing] = pushingIcon
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MotionRecorder.shared.startRecording(onSequenceRecorded: analyze)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MotionRecorder.shared.stopRecording()
        
        detectedMotion = nil
    }
    
    func analyze(sequence: [CMDeviceMotion]) {
        DispatchQueue.global().async {
            let inputs = MotionDetector.shared.inputs(for: sequence)
            let output: [Float] = MotionDetector.shared.analyze(inputs: inputs) ?? []
            let type = MotionType.by(output: output)
            let typeName = type?.rawValue.uppercased() ?? "NOTHING"
            
            DispatchQueue.main.async {
                self.detectedMotion = type
                
                Log.shared.write(entry: "Detected \(typeName)\nOutput: \(output)\n")
            }
        }
    }
}
