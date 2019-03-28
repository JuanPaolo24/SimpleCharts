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
  private var minValue: Double
  private var frameWidth: Double
  private var frameHeight: Double
  private var offSet: offset
  private var yAxisGridlineCount: Double
  private var xAxisGridlineCount: Double
  
  

  /// This initializer includes all the offset for the left, right, bottom and top in order for the user to completely customisate the graph
  required public init(array: [Double], arrayCount: Int, maxValue: Double, minValue: Double, frameWidth: Double, frameHeight: Double, offSet:offset, yAxisGridlineCount: Double, xAxisGridlineCount: Double) {
    self.array = array
    self.arrayCount = arrayCount
    self.maxValue = maxValue
    self.minValue = minValue
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    
    self.offSet = offSet
    self.yAxisGridlineCount = yAxisGridlineCount
    self.xAxisGridlineCount = xAxisGridlineCount
  }
  
  
  // Normal Line Graph
  
  func ylineGraphStartPoint() -> Double {
    let yAxisPadding = frameHeight - offSet.bottom
    let frameScale = frameHeight - offSet.bottom - offSet.top
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    var yValue = 0.0
    
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (frameScale / remaining) * negativeValue
    if let firstValue = array.first {
      yValue = (yAxisPadding - negativePadding) - ((frameScale / remaining) * firstValue)
    }
    return yValue
  }
  
  
  func ylineGraphPoint(value: Double) -> Double {
    let frameScale = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (frameScale / remaining) * negativeValue
    let yValue = (yAxisPadding - negativePadding) - ((frameScale / remaining) * value)

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
    let yOffSet = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let increment = spaceLeft / (arrayCount - 1)
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (yOffSet / remaining) * negativeValue
    
    
    let xPoint = offSet.left + (increment * Double(i + 1))
    let yPoint = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * value)
    
    
    let point = CGPoint(x: xPoint, y: yPoint)
    
    return point
  }
  
   // Calculation for the bezier point for combine charts
  func bezierCombinePoint(i: Int, value: Double) -> CGPoint {
    
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let yOffSet = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let scale = spaceLeft / (arrayCount * 2)
    
    let increment = spaceLeft / (arrayCount)
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (yOffSet / remaining) * negativeValue
    
    
    let xPoint = offSet.left + scale + (increment * Double(i + 1))
    let yPoint = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * value)
    
    let point = CGPoint(x: xPoint, y: yPoint)
    
    return point
  }
  
  
  
  func bezierControlPoint(i: Int, value: Double, intensity: Double, isControl1: Bool) -> CGPoint {
    let arrayCount = Double(array.count)
    let start = Array(array.dropLast())
    
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / (arrayCount - 1)
    let yOffSet = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let xPoint = offSet.left + (increment * Double(i + 1))
    let prevPoint = xPoint - increment
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (yOffSet / remaining) * negativeValue
    
    
    let yPoint = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * start[i])
    let nextValue = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * value)
    
    
    let xIntensity = (xPoint - prevPoint) * intensity
    let yIntensity = (yPoint - nextValue) * intensity
    
    
    var control = CGPoint()
    
    if isControl1 == true {
      control = CGPoint(x: prevPoint + xIntensity, y: yPoint + yIntensity)
    } else {
      control = CGPoint(x: xPoint - xIntensity, y: nextValue - yIntensity)
    }
    
    return control
    
  }

  
   // Calculation for the bezier points  for combine charts
  
  func bezierControlCombinedPoint(i: Int, value: Double, intensity: Double, isControl1: Bool) -> CGPoint {
    let arrayCount = Double(array.count)
    let start = Array(array.dropLast())

    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / (arrayCount)
    let yOffSet = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let scale = spaceLeft / (arrayCount * 2)
    let xPoint = offSet.left + scale + (increment * Double(i + 1))
    let prevPoint = xPoint - increment
    
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (yOffSet / remaining) * negativeValue
    
    
    let yPoint = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * start[i])
    let nextValue = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * value)

    let xIntensity = (xPoint - prevPoint) * intensity
    let yIntensity = (yPoint - nextValue) * intensity

    var control = CGPoint()
    
    if isControl1 == true {
      control = CGPoint(x: prevPoint + xIntensity, y: yPoint + yIntensity)
    } else {
      control = CGPoint(x: xPoint - xIntensity, y: nextValue - yIntensity)
    }
    
    return control

  }
  
  
  
  func xHorizontalAxisLabel(i: Int) -> Double {
    let spaceLeft = (frameWidth - 8) - (offSet.left + offSet.right)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < xAxisGridlineCount {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / (xAxisGridlineCount - 1)
    }
    
    let xValue = offSet.left + (increment * Double(i))
    
    return xValue
    
  }
  
  
  
// Axis Label
  func xAxisLabelxValue(i: Int) -> Double {
    let spaceLeft = (frameWidth - 8) - (offSet.left + offSet.right)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < xAxisGridlineCount {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / (xAxisGridlineCount)
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
    let frameScale = (frameHeight - offSet.bottom - offSet.top) / (yAxisGridlineCount - 1)
    let actualValue = frameScale * Double(i)

    let yValue = (frameHeight - offSet.bottom - 2) - actualValue
    
    return yValue
    
  }
  
  func yAxisLabelText(i: Int) -> String {
    let value = (maxValue - minValue) / (yAxisGridlineCount - 1)
    
    let text = String(Int(minValue) + (i * Int(value)))
    
    return text
  }
  
  
  
}
