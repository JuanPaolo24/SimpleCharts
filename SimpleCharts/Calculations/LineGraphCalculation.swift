//
//  LineGraphCalculation.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 01/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineGraphCalculation {
  
  private var array: [Double]
  private var arrayCount: Int
  private var maxValue: Double
  private var frameWidth: Double
  private var frameHeight: Double
  private var offSet: offset
  private var yAxisGridlineCount: Double
  private var xAxisGridlineCount: Double
  
  

  /// This initializer includes all the offset for the left, right, bottom and top in order for the user to completely customisate the graph
  required public init(array: [Double], arrayCount: Int, maxValue: Double, frameWidth: Double, frameHeight: Double, offSet:offset, yAxisGridlineCount: Double, xAxisGridlineCount: Double) {
    self.array = array
    self.arrayCount = arrayCount
    self.maxValue = maxValue
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    
    self.offSet = offSet
    self.yAxisGridlineCount = yAxisGridlineCount
    self.xAxisGridlineCount = xAxisGridlineCount
  }
  
  
  // Normal Line Graph
  
  func ylineGraphStartPoint() -> Double {
    let yAxisPadding = frameHeight - offSet.bottom
    var yValue = 0.0
    if let firstValue = array.first {
      yValue = yAxisPadding - ((yAxisPadding / maxValue) * firstValue)
    }
    return yValue
  }
  
  
  func ylineGraphPoint(value: Double) -> Double {
    let yAxisPadding = frameHeight - offSet.bottom
    let yValue = yAxisPadding - ((yAxisPadding / maxValue) * value)
    return yValue
  }
  

  func xlineGraphPoint(i: Int) -> Double {
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / (arrayCount - 1)
    let xValue = offSet.left + (increment * Double(i))
    
    return xValue
  }
  
  
  // Calculation for the line point for combine charts
  
  func xlineCombinePoint(i: Int) -> Double {
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / (arrayCount)
    let scale = spaceLeft / (arrayCount * 2)
    
    let xValue = offSet.left + scale + (increment * Double(i))
    
    return xValue
    
  }
  
  
  // Bezier Curve Graph
  
  
  func bezierGraphPoint(i: Int, value: Double) -> CGPoint {
    
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let yOffSet = frameHeight - offSet.bottom
    let increment = spaceLeft / (arrayCount - 1)
    let xPoint = offSet.left + (increment * Double(i + 1))
    let yPoint = yOffSet - ((yOffSet / maxValue) * value)
    
    let point = CGPoint(x: xPoint, y: yPoint)
    
    return point
  }
  
  func bezierControlPoint1(i: Int, value: Double, intensity: Double) -> CGPoint {
    let arrayCount = Double(array.count)
    let start = Array(array.dropLast())
    
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / (arrayCount - 1)
    let yOffSet = frameHeight - offSet.bottom
    let xPoint = offSet.left + (increment * Double(i + 1))
    let prevPoint = xPoint - increment
    let yPoint = yOffSet - ((yOffSet / maxValue) * start[i])
    let nextValue = yOffSet - ((yOffSet / maxValue) * value)
    
    
    let xIntensity = (xPoint - prevPoint) * intensity
    let yIntensity = (yPoint - nextValue) * intensity
    
    let control1 = CGPoint(x: prevPoint + xIntensity, y: yPoint + yIntensity)
    
    return control1
    
  }
  
  func bezierControlPoint2(i: Int, value: Double, intensity: Double) -> CGPoint {
    let arrayCount = Double(array.count)
    let start = Array(array.dropLast())
    
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / (arrayCount - 1)
    let yOffSet = frameHeight - offSet.bottom
    let xPoint = offSet.left + (increment * Double(i + 1))
    let prevPoint = xPoint - increment
    let yPoint = yOffSet - ((yOffSet / maxValue) * start[i])
    let nextValue = yOffSet - ((yOffSet / maxValue) * value)
    
    
    let xIntensity = (xPoint - prevPoint) * intensity
    let yIntensity = (yPoint - nextValue) * intensity
    
    let control2 = CGPoint(x: xPoint - xIntensity, y: nextValue - yIntensity)
    
    return control2
    
  }
  
  
  
  
// Axis Label
  func xAxisLabelxValue(i: Int) -> Double {
    let spaceLeft = (frameWidth - 8) - (offSet.left + offSet.right)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < 6 {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / xAxisGridlineCount
    }
    
    let xValue = offSet.left + (increment * Double(i))
    
    return xValue
    
  }
  
  func xAxisLabelyValue(isBottom: Bool) -> Double {
    var yValue = 0.0
    
    if isBottom == true {
      yValue = (frameHeight - offSet.bottom) + 10
    } else {
      yValue = offSet.top - 15
    }
    
    return yValue
  }
  
  func xAxisLabelText(i: Int) -> String {
    var scale = 0
    
    if arrayCount < 6 {
      scale = arrayCount / (arrayCount - 1)
    } else {
      scale = arrayCount / Int(xAxisGridlineCount)
    }
    
    let text = String(scale * i)
    
    return text
    
  }
  
  
  func yAxisLabelxValue(isLeft: Bool) -> Double {
    var xValue = 0.0
    
    if isLeft == true {
      xValue = offSet.left - 20
    } else {
      xValue = frameWidth - (offSet.right - 5)
    }
    
    
    return xValue
  }
  
  
  func yAxisLabelyValue(i: Int) -> Double {
    let frameScale = (frameHeight - offSet.bottom - offSet.top) / yAxisGridlineCount
    let actualValue = frameScale * Double(i)

    let yValue = (frameHeight - offSet.bottom - 2) - actualValue
    
    return yValue
    
  }
  
  func yAxisLabelText(i: Int) -> String {
    let actualDataScale = Int(maxValue / yAxisGridlineCount)
    
    let text = String(i * actualDataScale)
    
    return text
  }
  
  
  
}
