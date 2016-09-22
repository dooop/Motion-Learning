//
//  MotionType.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 22.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation

enum MotionType: String {
    
    case standing, walking, pushing
    
    static let all = [standing, walking, pushing]
    
    var output: [Float] {
        switch self {
        case .standing:
            return [1,0,0]
        case .walking:
            return [0,1,0]
        case .pushing:
            return [0,0,1]
        }
    }
    
    static func by(output: [Float]) -> MotionType? {
        guard let max = output.max(), let maxIndex = output.index(of: max), output.count == all.count else {
            return nil
        }
        
        return all[maxIndex]
    }
}
