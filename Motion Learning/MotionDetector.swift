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
    
    static let inputCount = 12
    static let outputCount = MotionType.all.count
    static let hidden = (inputCount * 2 / 3) + outputCount
    
    private let neuralNetwork =
        FFNN(inputs: inputCount, hidden: hidden, outputs: outputCount, learningRate: 0.7, momentum: 0.4, weights: nil, activationFunction: .Sigmoid, errorFunction: .CrossEntropy(average: false))
    
    func resetWeights() -> [Float] {
        try? neuralNetwork.resetWithWeights(weights: MotionType.weights)
        
        return neuralNetwork.getWeights()
    }
    
    func analyze(inputs: [Float]) -> [Float]? {
        return try? neuralNetwork.update(inputs: inputs)
    }
    
    func train(inputs: [Float], for type: MotionType) -> Float? {
        _ = try? neuralNetwork.update(inputs: inputs)
        
        return try? neuralNetwork.backpropagate(answer: type.answer)
    }
    
    func detect(inputs: [Float]) -> MotionType? {
        guard let output = try? neuralNetwork.update(inputs: inputs) else {
            return nil
        }

        return MotionType.by(output: output)
    }
    
    func inputs(for sequence: [CMDeviceMotion]) -> [Float] {
        var inputs = [Float]()
        
        let accelerationX  = sequence.flatMap({ Float($0.userAcceleration.x) })
        let accelerationY  = sequence.flatMap({ Float($0.userAcceleration.y) })
        let accelerationZ  = sequence.flatMap({ Float($0.userAcceleration.z) })
        
        inputs.append(Calculator.average(of: accelerationX))
        inputs.append(Calculator.average(of: accelerationY))
        inputs.append(Calculator.average(of: accelerationZ))
        inputs.append(Calculator.standardDeviation(of: accelerationX))
        inputs.append(Calculator.standardDeviation(of: accelerationY))
        inputs.append(Calculator.standardDeviation(of: accelerationZ))
        inputs.append(Calculator.energy(of: accelerationX))
        inputs.append(Calculator.energy(of: accelerationY))
        inputs.append(Calculator.energy(of: accelerationZ))
        inputs.append(Calculator.max(of: accelerationX))
        inputs.append(Calculator.max(of: accelerationY))
        inputs.append(Calculator.max(of: accelerationZ))
        
        return inputs
    }
}
