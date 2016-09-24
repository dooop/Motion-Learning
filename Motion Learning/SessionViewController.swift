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
        MotionRecorder.shared.startRecording(onSequenceRecorded: analyse)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MotionRecorder.shared.stopRecording()
        
        print("did disappear")
        detectedMotion = nil
    }
    
    func analyse(sequence: [CMDeviceMotion]) {
        DispatchQueue.global().async {
            let inputs = MotionDetector.shared.inputs(for: sequence)
            let type = MotionDetector.shared.detect(inputs: inputs)
            
            DispatchQueue.main.async {
                self.detectedMotion = type
            }
            
            Log.shared.write(entry: "\(type?.rawValue.uppercased() ?? "NOTHING") detected")
        }
    }
}
