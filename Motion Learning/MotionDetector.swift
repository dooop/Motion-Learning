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
        FFNN(inputs: inputCount, hidden: hidden, outputs: outputCount, learningRate: 0.7, momentum: 0.4, weights: MotionType.weights, activationFunction: .Sigmoid, errorFunction: .CrossEntropy(average: false))
    
    func resetWeights() -> Bool {
        do {
            try neuralNetwork.resetWithWeights(weights: MotionType.weights)
            return true
        }
        catch {
            return false
        }
    }
    
    func analyse(inputs: [Float]) -> [Float]? {
        return try? neuralNetwork.update(inputs: inputs)
    }
    
    func train(inputs: [Float], for type: MotionType) -> Float? {
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
        var inputs = [Float]()
        
        var accelerationX  = [Float]()
        var accelerationY  = [Float]()
        var accelerationZ  = [Float]()
        
        sequence.forEach { motion in
            accelerationX.append(Float(motion.userAcceleration.x))
            accelerationY.append(Float(motion.userAcceleration.y))
            accelerationZ.append(Float(motion.userAcceleration.z))
        }
        
        inputs.append(Calculator.average(of: accelerationX))
        inputs.append(Calculator.average(of: accelerationY))
        inputs.append(Calculator.average(of: accelerationZ))
        inputs.append(Calculator.standardDeviation(of: accelerationX))
        inputs.append(Calculator.standardDeviation(of: accelerationY))
        inputs.append(Calculator.standardDeviation(of: accelerationZ))
        inputs.append(Calculator.energy(of: accelerationX))
        inputs.append(Calculator.energy(of: accelerationY))
        inputs.append(Calculator.energy(of: accelerationZ))
        inputs.append(accelerationX.max() ?? 0)
        inputs.append(accelerationY.max() ?? 0)
        inputs.append(accelerationZ.max() ?? 0)
        
        return inputs
    }
}
