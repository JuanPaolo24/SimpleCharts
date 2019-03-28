//
//  BarGraphCalculation.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 01/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarGraphCalculation { 
  
  private var frameWidth: Double
  private var frameHeight: Double
  private var maxValue: Double
  private var minValue: Double
  private var arrayCount: Double
  
  private var offSet: offset

  
  /// Call this initializer unless you are using the horizontal gridline calculation
  public required init(frameHeight: Double, frameWidth: Double, maxValue: Double, minValue: Double, arrayCount: Double, offSet: offset) {
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.maxValue = maxValue
    self.minValue = minValue
    self.arrayCount = arrayCount
    
    self.offSet = offSet
  }
  
  
  
  // To make sure that the group data set is centered play around with the 10.0/10.0/15.0 parameters
  
  func xVerticalValue(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (arrayCount * count)
    let increment = (scale * count)
    let start = (offSet.left + 10.0) + (((scale) * dataSetCount) - 5.0) //Increase this to increase gap between data set
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
    let scale = spaceLeft / (arrayCount * count)
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
    let scale = spaceLeft / (arrayCount * count)
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
  
  
  func xGridlineStartCalculation(distanceIncrement: Int) -> CGPoint{
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let start = offSet.left + (increment * Double(distanceIncrement))
    
    let xValue = CGPoint(x: start, y: offSet.top)

    return xValue

  }

  func xGridlineEndCalculation(distanceIncrement: Int) -> CGPoint{
    let yAxisPadding = frameHeight - offSet.bottom
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let start = offSet.left + (increment * Double(distanceIncrement))

    let xValue = CGPoint(x: start, y: yAxisPadding)

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
    let scale = spaceLeft / (arrayCount * count)
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
    let scale = spaceLeft / (arrayCount * count)
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
    let scale = spaceLeft / (arrayCount * count)
    let increment = (scale * count)
    let start = (offSet.top + 10.0) + (((scale) * dataSetCount) - 5.0)
    let yFrame = start + (increment * Double(i))
    
    return yFrame
  }
  
  
  // Special gridline calculation for the Horizontal bar graph - Vertical bar graph can rely on the general graph calculation
  
  func xHorizontalGridline(i: Int, destination: position) -> CGPoint {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let increment = spaceLeft / arrayCount
    let xValue = offSet.left + (increment * Double(i))
    let yAxisPadding = frameHeight - offSet.bottom
    
    var point = CGPoint()
    
    if destination == position.start {
      point = CGPoint(x: xValue, y: offSet.top)
    } else {
      point = CGPoint(x: xValue, y: yAxisPadding)
    }
    
    return point
    
    
  }

  func yHorizontalGridline(i: Int, destination: position) -> CGPoint {
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
  
  
  //A special calculation for the vertical bar graph
  func xVerticalGraphxAxisLabel(i: Int) -> Double {
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let position = scale / 2
    let start = offSet.left + (increment * Double(i))
    

    let xValue = start + position
   

    
    return xValue
    
  }
  
  func xVerticalGraphyAxisLabel() -> Double {
    let yValue = frameHeight - (offSet.bottom - 7)
    
    return yValue
  }
  
  func horizontalYAxisLabelxPoint() -> Double {
    let xValue = offSet.left - 20
    
    return xValue
  }
  
  
  func horizontalYAxisLabelyPoint(i: Int) -> Double {
    let spaceLeft = frameHeight - (offSet.bottom + offSet.top)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let position = scale / 2
    let start = offSet.top + (increment * Double(i))
    let xValue = start + position
    
    return xValue
    
  }
  
  
  
}
