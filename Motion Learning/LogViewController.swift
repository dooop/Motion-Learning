//
//  LogViewController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 19.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var logLabel: UILabel!
    
    override func viewDidLoad() {
        updateLog(with: Log.shared.entries)
        
        Log.shared.entryWritten = updateLog
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollToBottom()
    }
    
    private func updateLog(with entries: [String]) {
        var log = ""
        
        for entry in entries {
            log = "\(log)\n\(entry)"
        }
        
        DispatchQueue.main.async {
            self.setLabel(with: log)
            self.scrollToBottom()
        }
    }
    
    private func setLabel(with log: String) {
        logLabel.text = log
        logLabel.sizeToFit()
        logLabel.layoutIfNeeded()
    }
    
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.scroller.contentSize.height - self.scroller.bounds.size.height)
        if bottomOffset.y > 0 {
            scroller.setContentOffset(bottomOffset, animated: true)
        }
    }
}
