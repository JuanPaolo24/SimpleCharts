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
    if chartData.count >= 1 {
      for i in 0...chartData.count-1 {
        array.append(chartData[i].array)
      }
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
  // Uses the binary search algorithm
  ///Refactor this soon 
  func returnClosestPoint(from array: [CGPoint], using target: CGPoint) -> CGPoint{
    let arrayCount = array.count
    var arrayStart = 0
    var arrayEnd = arrayCount
    var mid = 0
    
    while arrayStart < arrayEnd {
      mid = (arrayStart + arrayEnd) / 2
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
          return findClosest(target, between: array[mid-1], and: array[mid])
        }
        arrayEnd = mid
      } else {
        if mid < arrayCount-1 && target.x < array[mid+1].x {
          return findClosest(target, between: array[mid], and: array[mid+1])
        }
        arrayStart = mid + 1
      }
    }
    return array[mid]
  }
  
  /// finds the closest value for target.x between value 1 and value 2
  func findClosest(_ target: CGPoint, between value1: CGPoint, and value2: CGPoint) -> CGPoint {
    
    if (target.x - value1.x) >= (value2.x - target.x) {
      return value2
    } else {
      return value1
    }
  }
  
  // A variation of the findclosest function specially made to return a CGRect instead of a point
  func returnClosestRect(from array: [CGRect], using target: CGPoint) -> CGRect {
    let arrayCount = array.count
    var arrayStart = 0
    var arrayEnd = arrayCount
    var mid = 0
    
    while arrayStart < arrayEnd {
      mid = (arrayStart + arrayEnd) / 2
      if target.x <= array[0].midX {
        return array[0]
      }
      
      if target.x >= array[arrayCount-1].midX {
        return array[arrayCount-1]
      }
      
      if CGPoint(x: array[mid].midX, y: array[mid].minY) == target {
        return array[mid]
      }
      
      if target.x < array[mid].midX {
        if mid > 0 && target.x > array[mid-1].midX {
          return findClosestRect(target, between: array[mid-1], and: array[mid])
        }
        arrayEnd = mid
      } else {
        if mid < arrayCount-1 && target.x < array[mid+1].midX {
          return findClosestRect(target, between: array[mid], and: array[mid+1])
        }
        arrayStart = mid + 1
      }
    }
    return array[mid]
  }
  
    /// finds the closest value for target.x between value 1 and value 2
  func findClosestRect(_ target: CGPoint, between value1: CGRect, and value2: CGRect) -> CGRect {
    
    if (target.x - value1.midX) >= (value2.midX - target.x) {
      return value2
    } else {
      return value1
    }
  }
  
  
  func returnClosestHorizontal(from array: [CGRect], using target: CGPoint) -> CGRect {
    let arrayCount = array.count
    var arrayStart = 0
    var arrayEnd = arrayCount
    var mid = 0
    
    while arrayStart < arrayEnd {
      mid = (arrayStart + arrayEnd) / 2
      if target.x <= array[0].midY {
        return array[0]
      }
      
      if target.x >= array[arrayCount-1].midY {
        return array[arrayCount-1]
      }
      
      if CGPoint(x: array[mid].minX, y: array[mid].midY) == target {
        return array[mid]
      }
      
      if target.y < array[mid].midY {
        if mid > 0 && target.y > array[mid-1].midY {
          return findClosestHorizontal(target, between: array[mid-1], and: array[mid])
        }
        arrayEnd = mid
      } else {
        if mid < arrayCount-1 && target.y < array[mid+1].midY {
          return findClosestHorizontal(target, between: array[mid], and: array[mid+1])
        }
        arrayStart = mid + 1
      }
      
    }
    
    return array[mid]
  }
  
  /// finds the closest value for target.y between value 1 and value 2
  func findClosestHorizontal(_ target: CGPoint, between value1: CGRect, and value2: CGRect) -> CGRect {
    
    if (target.y - value1.midY) >= (value2.midY - target.y) {
      return value2
    } else {
      return value1
    }
  }
  
  /// Takes an array of array CGPoint and sort them by the x point
  func combineCGPoint(Array: [CGPoint]) -> [CGPoint]{
    let combinedArray = Array.sorted(by: { return $0.x < $1.x })
    
    
    return combinedArray
  }
  
  /// Takes an array of array CGRect and sort them by the midX point
  func combineCGRect(Array: [CGRect]) -> [CGRect] {
    let combinedArray = Array.sorted(by: { return $0.midX < $1.midX })
    
    return combinedArray
    
  }

  /// Takes an array of array CGRect and sort them by the midY point
  func combineCGRectHorizontal(Array: [CGRect]) -> [CGRect] {
    let combinedArray = Array.sorted(by: { return $0.midY < $1.midY })
    
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
