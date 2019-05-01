//
//  RendererHelper.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 18/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


class HelperFunctions {
  
  
  /// Takes in an array of array doubles and returns the max value between all of them
  //Also adds a bit of padding to make sure that the graph does not go off axis. Currently adds 20%
  open func findMaxValueFrom(_ array: [[Double]]) -> Double {
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
    
    let maxPadding = max * 0.2
    
    return max + maxPadding
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
  open func convertToDouble(from chartData: [ChartData]) -> [[Double]] {
    var array: [[Double]] = []
    for i in 0...chartData.count-1 {
      array.append(chartData[i].array)
    }
    return array
  }
  
  /// Converts chart data into an array of doubles
  open func convertToDouble(from chartData: ChartData) -> [Double] {
    var array: [Double] = []
    for i in 0...chartData.array.count-1 {
      array.append(chartData.array[i])
    }
    return array
  }
  

  // This function will take in an array and a target number and return the closest number from the array to the target number
  
  ///Refactor this soon 
  func findClosest(_ target: CGPoint, from array: [CGPoint]) -> CGPoint{
    let arrayCount = array.count
    var i = 0
    var j = arrayCount
    var mid = 0
    
    while i < j {
      mid = (i + j) / 2
      if target.x <= array[0].x {
        return array[0]
      }
      
      if target.x >= array[arrayCount-1].x {
        return array[arrayCount-1]
      }
      
      if array[mid] == target {
        return array[mid]
      }
      
      if target.x < array[mid].x {
        if mid > 0 && target.x > array[mid-1].x {
          return findClosestValue(target, between: array[mid-1], and: array[mid])
        }
        j = mid
      } else {
        if mid < arrayCount-1 && target.x < array[mid+1].x {
          return findClosestValue(target, between: array[mid], and: array[mid+1])
        }
        i = mid + 1
      }
      
    }
    
    return array[mid]
  }
  
  /// Helper function for finding the closest value between two values
  func findClosestValue(_ target: CGPoint, between value1: CGPoint, and value2: CGPoint) -> CGPoint {
    
    if (target.x - value1.x) >= (value2.x - target.x) {
      return value2
    } else {
      return value1
    }
  }
  
  
  func findClosestY(array: [CGRect], target: CGPoint) -> CGRect {
    let n = array.count
    var i = 0
    var j = n
    var mid = 0
    
    while i < j {
      mid = (i + j) / 2
      if target.x <= array[0].midX {
        return array[0]
      }
      
      if target.x >= array[n-1].midX {
        return array[n-1]
      }
      
      if CGPoint(x: array[mid].midX, y: array[mid].minY) == target {
        return array[mid]
      }
      
      if target.x < array[mid].midX {
        if mid > 0 && target.x > array[mid-1].midX {
          return findClosestBetweenTwoValuesY(value1: array[mid-1], value2: array[mid], target: target)
        }
        j = mid
      } else {
        if mid < n-1 && target.x < array[mid+1].midX {
          return findClosestBetweenTwoValuesY(value1: array[mid], value2: array[mid+1], target: target)
        }
        i = mid + 1
      }
      
    }
    
    return array[mid]
  }
  
  /// Helper function for finding the closest value between two values
  func findClosestBetweenTwoValuesY(value1: CGRect, value2: CGRect, target: CGPoint) -> CGRect {
    
    if (target.x - value1.midX) >= (value2.midX - target.x) {
      return value2
    } else {
      return value1
    }
  }
  
  
  func findClosestHorizontal(array: [CGRect], target: CGPoint) -> CGRect {
    let n = array.count
    var i = 0
    var j = n
    var mid = 0
    
    while i < j {
      mid = (i + j) / 2
      if target.x <= array[0].midY {
        return array[0]
      }
      
      if target.x >= array[n-1].midY {
        return array[n-1]
      }
      
      if CGPoint(x: array[mid].minX, y: array[mid].midY) == target {
        return array[mid]
      }
      
      if target.y < array[mid].midY {
        if mid > 0 && target.y > array[mid-1].midY {
          return findClosestBetweenTwoValuesHorizontal(value1: array[mid-1], value2: array[mid], target: target)
        }
        j = mid
      } else {
        if mid < n-1 && target.y < array[mid+1].midY {
          return findClosestBetweenTwoValuesHorizontal(value1: array[mid], value2: array[mid+1], target: target)
        }
        i = mid + 1
      }
      
    }
    
    return array[mid]
  }
  
  /// Helper function for finding the closest value between two values
  func findClosestBetweenTwoValuesHorizontal(value1: CGRect, value2: CGRect, target: CGPoint) -> CGRect {
    
    if (target.y - value1.midY) >= (value2.midY - target.y) {
      return value2
    } else {
      return value1
    }
  }
  

  /// Takes an array of array doubles and combines them in order
  func combineArray(array: [[Double]]) -> [Double]{
    let joined = Array(array.joined())
    
   return joined
  }
  
  
  /// Takes an array of array doubles and combines them in order
  func combineCGPointArray(array: [CGPoint]) -> [CGPoint]{
    let combinedArray = array.sorted(by: { return $0.x < $1.x })
    
    
    return combinedArray
  }
  
  func combineCGRectArray(array: [CGRect]) -> [CGRect] {
    let combinedArray = array.sorted(by: { return $0.midX < $1.midX })
    
    return combinedArray
    
  }

  
  func combineCGRectHorizontalArray(array: [CGRect]) -> [CGRect] {
    let combinedArray = array.sorted(by: { return $0.midY < $1.midY })
    
    return combinedArray
    
  }
  
  //Create a colour structure from a UIColour and returns an array of CGFloats corresponding to colour data
  func createColourStructure(from value: [UIColor]) -> [CGFloat] {
    var colorComponents: [CGFloat] = []
    
    for colours in value {
      guard let components = colours.cgColor.components else { return [] }
      colorComponents.append(components[0])
      colorComponents.append(components[1])
      colorComponents.append(components[2])
      colorComponents.append(components[3])
    }
    
    return colorComponents
    
  }
  
  
  
  
}
