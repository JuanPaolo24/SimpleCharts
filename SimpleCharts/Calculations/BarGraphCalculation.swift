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
  private var offSet: Double
  private var arrayCount: Double

  
  /// Call this initializer unless you are using the horizontal gridline calculation
  public required init(frameHeight: Double, frameWidth: Double, maxValue: Double, offSet: Double, arrayCount: Double) {
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.maxValue = maxValue
    self.offSet = offSet
    self.arrayCount = arrayCount
  }
  
  /// Call this initializer when using the horizontal gridline calculation
  public required init(frameHeight: Double, frameWidth: Double, offSet: Double, arrayCount: Double) {
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.maxValue = 0.0
    self.offSet = offSet
    self.arrayCount = arrayCount
  }
  
  func xVerticalValue(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameWidth - (offSet * 2)
    let scale = spaceLeft / (arrayCount * count)
    let increment = (scale * count)
    let start = offSet + (scale * dataSetCount)
    let xValue = start + (increment * Double(i))
    
    
    return xValue
  }
  
  
  func yVerticalValue(value: Double) -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = yAxisPadding - yValuePosition
    
    return yValue
  }
  
  
  func verticalWidth(count: Double) -> Double {
    let spaceLeft = frameWidth - (offSet * 2)
    let scale = spaceLeft / (arrayCount * count)
    let width = scale - 5.0
    
    
    return width
  }
  
  
  func verticalHeight(value: Double) -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = yAxisPadding - yValuePosition
    let height = yAxisPadding - yValue
    
    return height
  }
  
  func xVerticalTextFrame(i: Int) -> Double {
    let scale = (frameWidth - (offSet * 2)) / arrayCount
    let xValue = (offSet + 5) + (scale * Double(i))
    return xValue
  }
  
  func yVerticalTextFrame(value: Double) -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = (yAxisPadding - yValuePosition) - 15
    
    return yValue
  }
  
  
  ////This calculation works for the multiple data sets gridline - calculation vertical bar graph
  
  
//  func xGridlineStartCalculation(distanceIncrement: Int) -> CGPoint{
//    let spaceLeft = frameWidth - (offSet * 2)
//    let scale = spaceLeft / (arrayCount * 2)
//    let increment = (scale * 2)
//    let start = offSet + (increment * Double(distanceIncrement))
//
//    let xValue = CGPoint(x: start, y: 10)
//
//    return xValue
//
//  }
//
//  func xGridlineEndCalculation(distanceIncrement: Int) -> CGPoint{
//    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
//    let spaceLeft = frameWidth - (offSet * 2)
//    let scale = spaceLeft / (arrayCount * 2)
//    let increment = (scale * 2)
//    let start = offSet + (increment * Double(distanceIncrement))
//
//    let xValue = CGPoint(x: start, y: yAxisPadding)
//
//    return xValue
//  }
//
  
  
  
  
  // Horizontal graph calculations
  
  func xHorizontalValue() -> Double{
    return offSet
  }
  
  func yHorizontalValue(i: Int) -> Double {
    let scale = (frameHeight - currentFrame.distanceFromBottom) / arrayCount
    let yValue = 20 + (scale * Double(i))
    
    return yValue
  }
  
  func horizontalWidth(value: Double) -> Double {
    let xAxisPadding = frameWidth - currentFrame.distanceFromBottom
    let extraPadding = offSet - 30
    
    let width = ((xAxisPadding / maxValue) * value) - extraPadding
    
    return width
  }
  
  func horizontalHeight() -> Double {
    let scale = (frameHeight - currentFrame.distanceFromBottom - 10) / arrayCount
    let height = scale - 30
    
    return height
  }
  
  func xHorizontalTextFrame(value: Double) -> Double {
    let xAxisPadding = frameWidth - currentFrame.distanceFromBottom
    let extraPadding = offSet - 30
    
    let xValue = ((xAxisPadding / maxValue) * value) - extraPadding
    
    let xFrame = (offSet + xValue) + 5
    
    return xFrame
  }
  
  func yHorizontalTextFrame(i: Int) -> Double {
    var labelPadding = 25.0
    let scale = (frameHeight - currentFrame.distanceFromBottom) / arrayCount
    
    if offSet == 70 {
      labelPadding = 10.0
    }
    
    let yFrame = labelPadding + (scale * Double(i))
    
    return yFrame
  }
  
  
  // Special gridline calculation for the Horizontal bar graph - Vertical bar graph can rely on the general graph calculation
  
  func xHorizontalStartGridlines(i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSet * 2)
    let increment = spaceLeft / arrayCount
    let xValue = offSet + (increment * Double(i))
    
    let xStartPoint = CGPoint(x: xValue, y: 10)
    
    return xStartPoint
    
    
  }
  
  func xHorizontalEndGridlines(i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSet * 2)
    let increment = spaceLeft / arrayCount
    let xValue = offSet + (increment * Double(i))
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    
    let xEndPoint = CGPoint(x: xValue, y: yAxisPadding)
    
    return xEndPoint
  }
  
  
  func yHorizontalStartGridlines(i: Int) -> CGPoint {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let frameScale = (frameHeight - currentFrame.distanceFromBottom - 10) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    let yStartPoint = CGPoint(x: offSet, y: yPoint)
    
    
    return yStartPoint
  }
  
  func yHorizontalEndGridlines(i: Int) -> CGPoint {
    let xAxisPadding = frameWidth - offSet
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let frameScale = (frameHeight - currentFrame.distanceFromBottom) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    let yEndPoint = CGPoint(x: xAxisPadding, y: yPoint)
    
    return yEndPoint
    
  }
  
  
  //A special calculation for the vertical bar graph
  func xVerticalGraphxAxisLabel(i: Int) -> Double {
    let scale = (frameWidth - (offSet * 2)) / arrayCount
    let position = scale / 2
    let startPoint = offSet + ((scale) * Double(i))

    let xValue = startPoint + position
   
    
    return xValue
    
  }
  
  func xVerticalGraphyAxisLabel() -> Double {
    let yValue = frameHeight - 55
    
    return yValue
  }
  
  
  
  // Horizontal Bar Graph Label Calculation
  
  func horizontalXAxisLabelxPoint(i: Int) -> Double {
    let spaceLeft = (frameWidth - 8) - (offSet * 2)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < 6 {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / 6
    }
    
    let xValue = offSet + (increment * Double(i))
    
    return xValue
  }
  
  
  func horizontalXAxisLabelyPoint() -> Double {
    let yValue = frameHeight - 55
    return yValue
  }
  
  
  func horizontalXAxisText(i: Int) -> String {
    let actualDataScale = Int(maxValue / 6)
    let label = String(i * actualDataScale)
    
    return label
  }
  
  
  
  func horizontalYAxisLabelxPoint() -> Double {
    let xValue = offSet - 20
    
    return xValue
  }
  
  
  func horizontalYAxisLabelyPoint(i: Int) -> Double {
    let spaceLeft = (frameHeight - currentFrame.distanceFromBottom - 10) / arrayCount
    var startingPadding = 0.0
    var pad = 0.0
    
    //Landscape requires a different calculation
    if offSet == 70 {
      pad = 60
      startingPadding = offSet + 10
    } else {
      startingPadding = offSet + 30
    }

    let yValue = (startingPadding - pad) + (spaceLeft * Double(i))
    
    return yValue
    
  }
  
  
  
}
