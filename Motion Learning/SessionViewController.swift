//
//  SessionViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 19.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        activityIndicator.alpha = 0
    }
    
    // MARK: - Button actions
    
    @IBAction func start(_ sender: UIButton) {
        activityIndicator.show()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        activityIndicator.hide()
    }
    
    @IBAction func train(_ sender: UIButton) {
        // TODO
    }
}
