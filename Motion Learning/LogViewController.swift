//
//  LogViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 19.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet weak var logLabel: UILabel!
    
    override func viewDidLoad() {
        
        updateLog(with: Log.shared.entries)
        
        Log.shared.entryWritten = updateLog
    }
    
    private func updateLog(with entries: [String]) {
        var log = ""
        
        for entry in entries {
            log = "\(entry)\n\(log)"
        }
        
        DispatchQueue.main.async {
            self.setLabel(with: log)
        }
    }
    
    private func setLabel(with log: String) {
        logLabel.text = log
        logLabel.sizeToFit()
    }
}
