//
//  MotionRecognizer.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 21.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation
import CoreMotion

class MotionDetector {
    
    static let shared = MotionDetector()
    
    static let inputCount = 9
    static let outputCount = MotionType.all.count
    static let hidden = (inputCount * 2 / 3) + outputCount
    
    private let neuralNetwork =
        FFNN(inputs: inputCount, hidden: hidden, outputs: outputCount, learningRate: 0.7, momentum: 0.4, weights: nil, activationFunction: .Sigmoid, errorFunction: .CrossEntropy(average: false))
    
    func loadWeights() -> Bool {
        guard let weights = MotionType.weights else {
            return false
        }
        
        do {
            try neuralNetwork.resetWithWeights(weights: weights)
            return true
        }
        catch {
            return false
        }
    }
    
    func analyse(inputs: [Float]) -> [Float]? {
        return try? neuralNetwork.update(inputs: inputs)
    }
    
    func add(inputs: [Float], for type: MotionType) -> Float? {
        _ = try? neuralNetwork.update(inputs: inputs)
        return try? neuralNetwork.backpropagate(answer: type.output)
    }
    
    func detect(inputs: [Float]) -> MotionType? {
        guard let output = try? neuralNetwork.update(inputs: inputs) else {
            return nil
        }

        return MotionType.by(output: output)
    }
    
    func inputs(for sequence: [CMDeviceMotion]) -> [Float] {
        return []
    }
    
    
}
