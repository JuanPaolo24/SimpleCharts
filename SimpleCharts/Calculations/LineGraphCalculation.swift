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
  
  required public init() {
    self.array = []
    self.arrayCount = 0
    self.maxValue = 0
    self.minValue = 0
    self.frameWidth = 0
    self.frameHeight = 0
    
    self.offSet = offset(left: 0, right: 0, top: 0, bottom: 0)
    self.yAxisGridlineCount = 0
    self.xAxisGridlineCount = 0
    
  }
  
  //Gridlien calculation
  
  func yGridlinePoint(using i: Int, for destination: position) -> CGPoint {
    let frameScale = (frameHeight - offSet.bottom - offSet.top) / (yAxisGridlineCount - 1)
    let yAxisPadding = frameHeight - offSet.bottom
    let xAxisPadding = frameWidth - offSet.right
    let actualValue = frameScale * Double(i)
    var point = CGPoint()
    
    if destination == position.start {
      point = CGPoint(x: offSet.left, y: yAxisPadding - actualValue)
    } else {
      point = CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue)
    }
    
    
    return point
  }
  
  func xGridlinePoint(using distanceIncrement: Int, for destination: position) -> CGPoint {
    let yAxisPadding = frameHeight - offSet.bottom
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    var increment = 0.0
    if arrayCount < Int(xAxisGridlineCount) {
      increment = spaceLeft / Double(arrayCount - 1)
    } else {
      increment = spaceLeft / xAxisGridlineCount
    }
    
    let xValue = offSet.left + (increment * Double(distanceIncrement))
    var point = CGPoint()
    
    if destination == position.start {
      point = CGPoint(x: xValue, y: offSet.top)
    } else {
      point = CGPoint(x: xValue, y: yAxisPadding)
    }
    
    return point
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
  

  func xlineGraphPoint(for type: chartType, from i: Int) -> Double {
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    var increment = 0.0
    let scale = spaceLeft / (arrayCount * 2)
    var xValue = 0.0
    
    if type == .combineChart {
      increment = spaceLeft / (arrayCount)
      xValue = offSet.left + scale + (increment * Double(i))
    } else {
      increment = spaceLeft / (arrayCount - 1)
      xValue = offSet.left + (increment * Double(i))
    }
    
    
    return xValue
  }
  

  // Bezier Curve Graph
  
  
  func bezierGraphPoint(for type: chartType, from i: Int, and value: Double) -> CGPoint {
    
    let arrayCount = Double(array.count)
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let yOffSet = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let scale = spaceLeft / (arrayCount * 2)
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    let negativePadding = (yOffSet / remaining) * negativeValue
    let yPoint = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * value)
    
    var increment = 0.0
    var xPoint = 0.0
    
    if type == .combineChart {
      increment = spaceLeft / (arrayCount)
      xPoint = offSet.left + scale + (increment * Double(i + 1))
    } else {
      increment = spaceLeft / (arrayCount - 1)
      xPoint = offSet.left + (increment * Double(i + 1))
    }
    
    let point = CGPoint(x: xPoint, y: yPoint)
    
    return point
  }
  
  
  func bezierControlPoint(_ controlNumber: Int, for type: chartType, from i: Int, and value: Double, with intensity: Double) -> CGPoint {
    let arrayCount = Double(array.count)
    let start = Array(array.dropLast())
    
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let yOffSet = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    let scale = spaceLeft / (arrayCount * 2)
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    
    let negativePadding = (yOffSet / remaining) * negativeValue
    var increment = 0.0
   
    var xPoint = 0.0
    var prevPoint = 0.0
    
    if type == .combineChart {
      increment = spaceLeft / (arrayCount)
      xPoint = offSet.left + scale + (increment * Double(i + 1))
      prevPoint = xPoint - increment
    } else {
      increment = spaceLeft / (arrayCount - 1)
      xPoint = offSet.left + (increment * Double(i + 1))
      prevPoint = xPoint - increment
    }
   
    let yPoint = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * start[i])
    let nextValue = (yAxisPadding - negativePadding) - ((yOffSet / remaining) * value)
    
    let xIntensity = (xPoint - prevPoint) * intensity
    let yIntensity = (yPoint - nextValue) * intensity
    
    
    var control = CGPoint()
    
    if controlNumber == 1 {
      control = CGPoint(x: prevPoint + xIntensity, y: yPoint + yIntensity)
    } else {
      control = CGPoint(x: xPoint - xIntensity, y: nextValue - yIntensity)
    }
    
    return control
    
  }
  

  func xAxisLabel(using i: Int, andisBottom isBottom: Bool) -> CGPoint {
    let spaceLeft = (frameWidth - 8) - (offSet.left + offSet.right)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < xAxisGridlineCount {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / (xAxisGridlineCount)
    }
    let xValue = offSet.left + (increment * Double(i))
    
    var yValue = 0.0
    
    if isBottom == true {
      yValue = (frameHeight - offSet.bottom) + 10
    } else {
      yValue = offSet.top - 15
    }
    
    return CGPoint(x: xValue, y: yValue)
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
  
  
  func yAxisLabel(using i: Int, andisLeft isLeft: Bool) -> CGPoint {
    let frameScale = (frameHeight - offSet.bottom - offSet.top) / (yAxisGridlineCount - 1)
    let actualValue = frameScale * Double(i)
    var xValue = 0.0
    
    if isLeft == true {
      xValue = offSet.left - 20
    } else {
      xValue = frameWidth - (offSet.right - 5)
    }
    let yValue = (frameHeight - offSet.bottom - 2) - actualValue
    
    return CGPoint(x: xValue, y: yValue)
    
  }
  
  func yAxisLabelText(using i: Int) -> String {
    let value = (maxValue - minValue) / (yAxisGridlineCount - 1)

    let text = String(Int(minValue) + (i * Int(value)))

    return text
  }
  
  
  
  func xVerticalValue(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (Double(arrayCount) * count)
    let increment = (scale * count)
    let start = (offSet.left + 10.0) + (((scale) * dataSetCount) - 5.0)
    let xValue = start + (increment * Double(i))
    
    return xValue
  }
  
  
  func yVerticalValue(value: Double) -> Double {
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
  
  
  func verticalWidth(count: Double) -> Double {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (Double(arrayCount) * count)
    let width = scale - 10
    
    
    return width
  }
  
  
  func verticalHeight(value: Double) -> Double {
    let frameScale = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    
    let negativePadding = (frameScale / remaining) * negativeValue
    
    let yValue = (yAxisPadding - negativePadding) - ((frameScale / remaining) * value)
    let height = (yAxisPadding - negativePadding) - yValue
    
    return height
  }
  
  func xVerticalTextFrame(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (Double(arrayCount) * count)
    let increment = (scale * count)
    let start = (offSet.left + 10.0) + (((scale) * dataSetCount) - 5.0)
    let xValue = (start) + (increment * Double(i))
    
    
    return xValue
  }
  
  func yVerticalTextFrame(value: Double) -> Double {
    let frameScale = frameHeight - offSet.bottom - offSet.top
    let yAxisPadding = frameHeight - offSet.bottom
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    var labelPadding = -15.0
    
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    
    if value < 0 {
      labelPadding = 5.0
    }
    
    let negativePadding = (frameScale / remaining) * negativeValue
    
    let yValue = (yAxisPadding - negativePadding + labelPadding) - ((frameScale / remaining) * value)
    
    return yValue
  }
  
  
  //This calculation works for the multiple data sets gridline - calculation vertical bar graph
  
  func barXGridlinePoint(using distanceIncrement: Int, for position: position) -> CGPoint {
    let yAxisPadding = frameHeight - offSet.bottom
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (Double(arrayCount) * 2)
    let increment = (scale * 2)
    let start = offSet.left + (increment * Double(distanceIncrement))
    
    var xValue = CGPoint()
    
    if position == .start {
      xValue = CGPoint(x: start, y: offSet.top)
    } else {
      xValue = CGPoint(x: start, y: yAxisPadding)
    }
    return xValue
  }
  
  
  
  // Horizontal graph calculations
  
  func xHorizontalValue() -> Double{
    let frameScale = frameWidth - offSet.left - offSet.right
    
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    
    let negativePadding = (frameScale / remaining) * negativeValue
    
    let xValue = offSet.left + negativePadding
    
    return xValue
  }
  
  func yHorizontalValue(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameHeight - (offSet.bottom + offSet.top)
    let scale = spaceLeft / (Double(arrayCount) * count)
    let increment = (scale * count)
    let start = (offSet.top + 10.0) + (((scale) * dataSetCount) - 5.0)
    let yValue = start + (increment * Double(i))
    
    return yValue
  }
  
  func horizontalWidth(value: Double) -> Double {
    let xAxisPadding = frameWidth - (offSet.left + offSet.right)
    let remaining = maxValue - minValue
    
    
    
    let width = ((xAxisPadding / remaining) * value)
    
    return width
  }
  
  func horizontalHeight(count: Double) -> Double {
    let spaceLeft = frameHeight - (offSet.bottom + offSet.top)
    let scale = spaceLeft / (Double(arrayCount) * count)
    let height = scale - 10
    
    return height
  }
  
  func xHorizontalTextFrame(value: Double) -> Double {
    
    let frameScale = frameWidth - (offSet.left + offSet.right)
    let remaining = maxValue - minValue
    var negativeValue = 0.0
    var labelPadding = 5.0
    
    if minValue < 0 {
      negativeValue = abs(minValue)
    }
    
    if value < 0 {
      labelPadding = -28.0
    }
    
    let negativePadding = (frameScale / remaining) * negativeValue
    
    let xValuePosition = (frameScale / remaining) * value
    let xValue = offSet.left + negativePadding + xValuePosition + labelPadding
    
    return xValue
  }
  
  func yHorizontalTextFrame(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameHeight - (offSet.bottom + offSet.top)
    let scale = spaceLeft / (Double(arrayCount) * count)
    let increment = (scale * count)
    let start = (offSet.top + 10.0) + (((scale) * dataSetCount) - 5.0)
    let yFrame = start + (increment * Double(i))
    
    return yFrame
  }
  
  
  // Special gridline calculation for the Horizontal bar graph - Vertical bar graph can rely on the general graph calculation
  
  func xHorizontalGridline(using i: Int, for destination: position) -> CGPoint {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    var increment = 0.0
    let count = Double(arrayCount)
    
    let yAxisPadding = frameHeight - offSet.bottom
    
    if count < xAxisGridlineCount {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / (xAxisGridlineCount - 1)
    }
    let xValue = offSet.left + (increment * Double(i))
    
    var point = CGPoint()
    
    if destination == position.start {
      point = CGPoint(x: xValue, y: offSet.top)
    } else {
      point = CGPoint(x: xValue, y: yAxisPadding)
    }
    
    return point
    
    
  }
  
  func yHorizontalGridline(using i: Int, for destination: position) -> CGPoint {
    let xAxisPadding = frameWidth - offSet.right
    let yAxisPadding = frameHeight - offSet.bottom
    let frameScale = (frameHeight - offSet.bottom - offSet.top) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    var point = CGPoint()
    
    if destination == position.start {
      point = CGPoint(x: offSet.left, y: yPoint)
    } else {
      point = CGPoint(x: xAxisPadding, y: yPoint)
    }
    
    return point
  }
  
  
  func barXAxisLabel(using i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (Double(arrayCount) * 2)
    let increment = (scale * 2)
    let position = scale / 2
    let start = offSet.left + (increment * Double(i))
    let xValue = start + position
    let yValue = frameHeight - (offSet.bottom - 7)
    
    return CGPoint(x: xValue, y: yValue)
  }
  
  func horizontalYAxisLabel(using i: Int) -> CGPoint {
    let spaceLeft = frameHeight - (offSet.bottom + offSet.top)
    let scale = spaceLeft / (Double(arrayCount) * 2)
    let increment = (scale * 2)
    let position = scale / 2
    let start = offSet.top + (increment * Double(i))
    let xValue = offSet.left - 20
    let yValue = start + position
    
    
    return CGPoint(x: xValue, y: yValue)
  }
  
  func horizontalXAxisLabel(using i: Int) -> CGPoint {
    let spaceLeft = (frameWidth - 8) - (offSet.left + offSet.right)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < xAxisGridlineCount {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / (xAxisGridlineCount - 1)
    }
    
    let xValue = offSet.left + (increment * Double(i))
    let yValue = (frameHeight - offSet.bottom) + 10
    
    return CGPoint(x: xValue, y: yValue)
  }
  
}
