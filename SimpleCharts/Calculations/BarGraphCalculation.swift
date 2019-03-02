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
  private var initialValue: Double
  private var arrayCount: Double

  
  /// Call this initializer unless you are using the horizontal gridline calculation
  public required init(frameHeight: Double, frameWidth: Double, maxValue: Double, initialValue: Double, arrayCount: Double) {
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.maxValue = maxValue
    self.initialValue = initialValue
    self.arrayCount = arrayCount
  }
  
  /// Call this initializer when using the horizontal gridline calculation
  public required init(frameHeight: Double, frameWidth: Double, initialValue: Double, arrayCount: Double) {
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.maxValue = 0.0
    self.initialValue = initialValue
    self.arrayCount = arrayCount
  }
  
  // Vertical graph calculations
  
  func xVerticalValue(i: Int) -> Double {
    let scale = (frameWidth - (initialValue * 2)) / arrayCount
    let xValue = initialValue + (scale * Double(i))
    
    return xValue
  }
  
  func yVerticalValue(value: Double) -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = yAxisPadding - yValuePosition
    
    return yValue
  }
  
  func verticalWidth() -> Double {
    let scale = (frameWidth - (initialValue * 2)) / arrayCount
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
    let scale = (frameWidth - (initialValue * 2)) / arrayCount
    let xValue = (initialValue + 5) + (scale * Double(i))
    return xValue
  }
  
  func yVerticalTextFrame(value: Double) -> Double {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = (yAxisPadding - yValuePosition) - 15
    
    return yValue
  }
  
  
  
  // Horizontal graph calculations
  
  func xHorizontalValue() -> Double{
    return initialValue
  }
  
  func yHorizontalValue(i: Int) -> Double {
    let scale = (frameHeight - currentFrame.distanceFromBottom) / arrayCount
    let yValue = 20 + (scale * Double(i))
    
    return yValue
  }
  
  func horizontalWidth(value: Double) -> Double {
    let xAxisPadding = frameWidth - currentFrame.distanceFromBottom
    let extraPadding = initialValue - 30
    
    let width = ((xAxisPadding / maxValue) * value) - extraPadding
    
    return width
  }
  
  func horizontalHeight() -> Double {
    let scale = (frameHeight - currentFrame.distanceFromBottom) / arrayCount
    let height = scale - 35
    
    return height
  }
  
  func xHorizontalTextFrame(value: Double) -> Double {
    let xAxisPadding = frameWidth - currentFrame.distanceFromBottom
    let extraPadding = initialValue - 30
    
    let xValue = ((xAxisPadding / maxValue) * value) - extraPadding
    
    let xFrame = (initialValue + xValue) + 5
    
    return xFrame
  }
  
  func yHorizontalTextFrame(i: Int) -> Double {
    var labelPadding = 25.0
    let scale = (frameHeight - currentFrame.distanceFromBottom) / arrayCount
    
    if initialValue == 70 {
      labelPadding = 10.0
    }
    
    let yFrame = labelPadding + (scale * Double(i))
    
    return yFrame
  }
  
  
  // Special gridline calculation for the Horizontal bar graph - Vertical bar graph can rely on the general graph calculation
  
  func xHorizontalStartGridlines(i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / arrayCount
    let xValue = initialValue + (increment * Double(i))
    
    let xStartPoint = CGPoint(x: xValue, y: 10)
    
    return xStartPoint
    
    
  }
  
  func xHorizontalEndGridlines(i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / arrayCount
    let xValue = initialValue + (increment * Double(i))
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    
    let xEndPoint = CGPoint(x: xValue, y: yAxisPadding)
    
    return xEndPoint
  }
  
  
  func yHorizontalStartGridlines(i: Int) -> CGPoint {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let frameScale = (frameHeight - currentFrame.distanceFromBottom) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    let yStartPoint = CGPoint(x: initialValue, y: yPoint)
    
    return yStartPoint
  }
  
  func yHorizontalEndGridlines(i: Int) -> CGPoint {
    let xAxisPadding = frameWidth - initialValue
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let frameScale = (frameHeight - currentFrame.distanceFromBottom) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    let yEndPoint = CGPoint(x: xAxisPadding, y: yPoint)
    
    return yEndPoint
    
  }
  
  
  //A special calculation for the vertical bar graph
  func xVerticalGraphxAxisLabel(i: Int) -> Double {
    let scale = (frameWidth - (initialValue * 2)) / arrayCount
    let barWidth = scale - 5.0
    let position = barWidth / 2
    let startPoint = initialValue + ((barWidth + 5) * Double(i))

    let xValue = startPoint + position
   
    
    return xValue
    
  }
  
  func xVerticalGraphyAxisLabel() -> Double {
    let yValue = frameHeight - 55
    
    return yValue
  }
  
  
  
  // Horizontal Bar Graph Label Calculation
  
  func horizontalXAxisLabelxPoint(i: Int) -> Double {
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / (arrayCount)
    let xValue = initialValue + (increment * Double(i))
    
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
    let xValue = initialValue - 20
    
    return xValue
  }
  
  
  func horizontalYAxisLabelyPoint(i: Int) -> Double {
    var scale = 0.0
    var pad = 0.0
    
    //Landscape requires a different calculation
    if initialValue == 70 {
      scale = (frameHeight - 52) - (initialValue / 2) / Double(arrayCount - 1)
      pad = 60
    } else {
      scale = (frameHeight - 62) - (initialValue * 2) / Double(arrayCount - 1)
    }
    
    let yValue = (initialValue - pad) + (scale * Double(i))
    
    return yValue
    
  }
  
  
  
}
