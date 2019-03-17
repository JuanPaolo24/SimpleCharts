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
  private var arrayCount: Double
  
  private var offSetTop: Double
  private var offSetBottom: Double
  private var offSetLeft: Double
  private var offSetRight: Double

  
  /// Call this initializer unless you are using the horizontal gridline calculation
  public required init(frameHeight: Double, frameWidth: Double, maxValue: Double, arrayCount: Double, offSetTop: Double, offSetBottom: Double, offSetLeft: Double, offSetRight: Double) {
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.maxValue = maxValue
    self.arrayCount = arrayCount
    
    self.offSetTop = offSetTop
    self.offSetBottom = offSetBottom
    self.offSetRight = offSetRight
    self.offSetLeft = offSetLeft
  }
  
  
  
  // To make sure that the group data set is centered play around with the 10.0/10.0/15.0 parameters
  
  func xVerticalValue(i: Int, dataSetCount: Double, count: Double) -> Double {
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let scale = spaceLeft / (arrayCount * count)
    let increment = (scale * count)
    let start = (offSetLeft + 10.0) + (((scale) * dataSetCount) - 5.0) //Increase this to increase gap between data set
    let xValue = start + (increment * Double(i))
    
    
    return xValue
  }
  
  
  func yVerticalValue(value: Double) -> Double {
    let yAxisPadding = frameHeight - offSetBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = yAxisPadding - yValuePosition
    
    return yValue
  }
  
  
  func verticalWidth(count: Double) -> Double {
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let scale = spaceLeft / (arrayCount * count)
    let width = scale - 10
    
    
    return width
  }
  
  
  func verticalHeight(value: Double) -> Double {
    let yAxisPadding = frameHeight - offSetBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = yAxisPadding - yValuePosition
    let height = yAxisPadding - yValue
    
    return height
  }
  
  func xVerticalTextFrame(i: Int) -> Double {
    let scale = (frameWidth - (offSetLeft + offSetRight)) / arrayCount
    let xValue = (offSetLeft + 5) + (scale * Double(i))
    return xValue
  }
  
  func yVerticalTextFrame(value: Double) -> Double {
    let yAxisPadding = frameHeight - offSetBottom
    let yValuePosition = (yAxisPadding / maxValue) * value
    let yValue = (yAxisPadding - yValuePosition) - 15
    
    return yValue
  }
  
  
  //This calculation works for the multiple data sets gridline - calculation vertical bar graph
  
  
  func xGridlineStartCalculation(distanceIncrement: Int) -> CGPoint{
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let start = offSetLeft + (increment * Double(distanceIncrement))
    
    let xValue = CGPoint(x: start, y: offSetTop)

    return xValue

  }

  func xGridlineEndCalculation(distanceIncrement: Int) -> CGPoint{
    let yAxisPadding = frameHeight - offSetBottom
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let start = offSetLeft + (increment * Double(distanceIncrement))

    let xValue = CGPoint(x: start, y: yAxisPadding)

    return xValue
  }

  
  
  
  
  // Horizontal graph calculations
  
  func xHorizontalValue() -> Double{
    return offSetLeft
  }
  
  func yHorizontalValue(i: Int) -> Double {
    let scale = (frameHeight - offSetBottom) / arrayCount
    let yValue = 20 + (scale * Double(i))
    
    return yValue
  }
  
  func horizontalWidth(value: Double) -> Double {
    let xAxisPadding = frameWidth - offSetBottom
    let extraPadding = offSetLeft - 30
    
    let width = ((xAxisPadding / maxValue) * value) - extraPadding
    
    return width
  }
  
  func horizontalHeight() -> Double {
    let scale = (frameHeight - offSetBottom - offSetTop) / arrayCount
    let height = scale - 30
    
    return height
  }
  
  func xHorizontalTextFrame(value: Double) -> Double {
    let xAxisPadding = frameWidth - offSetBottom
    let extraPadding = offSetLeft - 30
    
    let xValue = ((xAxisPadding / maxValue) * value) - extraPadding
    
    let xFrame = (offSetLeft + xValue) + 5
    
    return xFrame
  }
  
  func yHorizontalTextFrame(i: Int) -> Double {
    var labelPadding = 25.0
    let scale = (frameHeight - offSetBottom) / arrayCount
    
    if offSetLeft == 70 {
      labelPadding = 10.0
    }
    
    let yFrame = labelPadding + (scale * Double(i))
    
    return yFrame
  }
  
  
  // Special gridline calculation for the Horizontal bar graph - Vertical bar graph can rely on the general graph calculation
  
  func xHorizontalStartGridlines(i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let increment = spaceLeft / arrayCount
    let xValue = offSetLeft + (increment * Double(i))
    
    let xStartPoint = CGPoint(x: xValue, y: offSetTop)
    
    return xStartPoint
    
    
  }
  
  func xHorizontalEndGridlines(i: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let increment = spaceLeft / arrayCount
    let xValue = offSetLeft + (increment * Double(i))
    let yAxisPadding = frameHeight - offSetBottom
    
    let xEndPoint = CGPoint(x: xValue, y: yAxisPadding)
    
    return xEndPoint
  }
  
  
  func yHorizontalStartGridlines(i: Int) -> CGPoint {
    let yAxisPadding = frameHeight - offSetBottom
    let frameScale = (frameHeight - offSetBottom - offSetTop) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    let yStartPoint = CGPoint(x: offSetLeft, y: yPoint)
    
    
    return yStartPoint
  }
  
  func yHorizontalEndGridlines(i: Int) -> CGPoint {
    let xAxisPadding = frameWidth - offSetLeft
    let yAxisPadding = frameHeight - offSetBottom
    let frameScale = (frameHeight - offSetBottom - offSetTop) / Double(arrayCount)
    let actualValue = frameScale * Double(i)
    let yPoint = yAxisPadding - actualValue
    
    let yEndPoint = CGPoint(x: xAxisPadding, y: yPoint)
    
    return yEndPoint
    
  }
  
  
  //A special calculation for the vertical bar graph
  func xVerticalGraphxAxisLabel(i: Int) -> Double {
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    let scale = spaceLeft / (arrayCount * 2)
    let increment = (scale * 2)
    let position = scale / 2
    let start = offSetLeft + (increment * Double(i))
    

    let xValue = start + position
   

    
    return xValue
    
  }
  
  func xVerticalGraphyAxisLabel() -> Double {
    let yValue = frameHeight - (offSetBottom - 7)
    
    return yValue
  }
  
  
  
  // Horizontal Bar Graph Label Calculation
  
  func horizontalXAxisLabelxPoint(i: Int) -> Double {
    let spaceLeft = (frameWidth - 8) - (offSetLeft + offSetRight)
    var increment = 0.0
    let count = Double(arrayCount)
    
    if count < 6 {
      increment = spaceLeft / (count - 1)
    } else {
      increment = spaceLeft / 6
    }
    
    let xValue = offSetLeft + (increment * Double(i))
    
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
    let xValue = offSetLeft - 20
    
    return xValue
  }
  
  
  func horizontalYAxisLabelyPoint(i: Int) -> Double {
    let spaceLeft = (frameHeight - offSetBottom - offSetTop) / arrayCount
    var startingPadding = 0.0
    var pad = 0.0
    
    //Landscape requires a different calculation
    if offSetLeft == 70 {
      pad = 60
      startingPadding = offSetLeft + 10
    } else {
      startingPadding = offSetLeft + 30
    }

    let yValue = (startingPadding - pad) + (spaceLeft * Double(i))
    
    return yValue
    
  }
  
  
  
}
