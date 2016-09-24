//
//  Log.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 20.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation

class Log {
    
    static let shared = Log()
    
    private let maxEntries = 420
    
    private(set) var entries: [String] = []
    
    var entryWritten: ((_ entries: [String]) -> Void)?
    
    func write(entry: String) {
        if entries.count > maxEntries {
            entries.removeFirst()
        }
        
        entries.append(entry)
        entryWritten?(entries)
        
        print(entry)
    }
    
    func clear() {
        entries.removeAll()
        entryWritten?(entries)
    }
}
