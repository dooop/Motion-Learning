//
//  AppDelegate.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 18.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let weights = MotionDetector.shared.resetWeights()
        
        Log.shared.clear()
        Log.shared.write(entry: "Weights: \(weights)\n")
        
        return true
    }
}

