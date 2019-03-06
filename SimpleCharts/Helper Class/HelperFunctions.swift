//
//  RendererHelper.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 18/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


class HelperFunctions {
  
  
  /// Takes in multiple arrays and determines the highest value within all arrays and returns it
  open func processMultipleArrays(array: [[Double]]) -> Double {
    var max = 0.0
    var newArray: [Double] = []
    
    for i in array {
      if let maxValue = i.max() {
        newArray.append(maxValue)
      }
    }
    
    if let newMax = newArray.max() {
      max = newMax
    }
    
    return max + 41
  }
  
  /// Returns the max value from an array
  open func returnMaxValueFrom(array: [Double]) -> Double {
    var max = 0.0
    if let maxValue = array.max() {
      max = maxValue
    }
    return max + 41
  }
  
  
  /// Takes in multiple arrays and within those array determine the array with the highest count and returns that count
  open func findArrayCountFrom(array: [[Double]]) -> Int {
    var arrayCount = 0
    var countArray: [Int] = []
    
    for i in array {
      countArray.append(i.count)
    }
    
    if let newMax = countArray.max() {
      arrayCount = newMax
    }
    
    return arrayCount
  }

  /// Converts the an array of chart data into an array of array doubles
  open func convert(chartData: [ChartData]) -> [[Double]] {
    var array: [[Double]] = []
    for i in 0...chartData.count-1 {
      array.append(chartData[i].array)
    }
    return array
  }
  
  /// Converts chart data into an array of doubles
  open func convert(chartData: ChartData) -> [Double] {
    var array: [Double] = []
    for i in 0...chartData.array.count-1 {
      array.append(chartData.array[i])
    }
    return array
  }
  
  
  /// Check if the bounds of the array has been reached
  func checkBounds(_ i: Int, array: [Double]) -> Double? {
    guard i >= array.startIndex, i < array.endIndex else {
      return nil
    }
    return array[i]
    
  }

}
