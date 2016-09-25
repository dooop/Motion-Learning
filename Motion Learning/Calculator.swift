//
//  Calculator.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 23.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import Foundation
import Accelerate

class Calculator {
    
    static func fastFourierTransformation(of values: [Float]) -> [Float] {
        var real = [Float](values)
        var imaginary = [Float](repeating: 0.0, count: values.count)
        var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
        
        let length = vDSP_Length(floor(log2(Float(values.count))))
        let radix = FFTRadix(kFFTRadix2)
        
        guard let weights = vDSP_create_fftsetup(length, radix) else {
            return []
        }
        
        vDSP_fft_zip(weights, &splitComplex, 1, length, FFTDirection(FFT_FORWARD))
        
        var magnitudes = [Float](repeating: 0.0, count: values.count)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(values.count))
        
        var normalizedMagnitudes = [Float](repeating: 0.0, count: values.count)
        vDSP_vsmul(sqrt(of: magnitudes), 1, [2.0 / Float(values.count)], &normalizedMagnitudes, 1, vDSP_Length(values.count))
        
        vDSP_destroy_fftsetup(weights)
        
        return normalizedMagnitudes
    }
    
    static func sqrt(of values: [Float]) -> [Float] {
        var results = [Float](repeating: 0.0, count: values.count)
        vvsqrtf(&results, values, [Int32(values.count)])
        
        return results
    }
    
    static func standardDeviation(of values: [Float]) -> Float {
        let variance = self.variance(of: values)
        
        return sqrtf(variance)
    }
    
    static func variance(of values: [Float]) -> Float {
        let average = self.average(of: values)
        var sum: Float = 0.0
        for value in values {
            sum += powf(value - average, 2)
        }
        let variance: Float = sum / Float(values.count)
        
        return variance
    }
    
    static func average(of values: [Float]) -> Float {
        var sum: Float = 0.0
        for value in values {
            sum += value
        }
        let average: Float = sum / Float(values.count)
        
        return average
    }
    
    static func energy(of values: [Float]) -> Float {
        let fft = self.fastFourierTransformation(of: values)
        var sum: Float = 0.0
        for value in fft {
            sum += powf(value, 2)
        }
        let energy: Float = sum / Float(values.count)
        
        return energy
    }
    
    static func max(of values: [Float]) -> Float {
        let max = values.max() ?? 0
        
        return max
    }
}
