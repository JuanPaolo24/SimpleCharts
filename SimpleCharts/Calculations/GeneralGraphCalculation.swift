//
//  GeneralGraphCalculation.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 01/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class GeneralGraphCalculation {
  
  private var offSet: Double
  private var frameWidth: Double
  private var frameHeight: Double
  private var arrayCount: Double
  
  
  /// Initialize this when using the gridline calculation for the Y axis
  public required init(frameHeight: Double, frameWidth: Double, offSet: Double) {
    self.offSet = offSet
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.arrayCount = 0.0
  }
  
  /// Initialize this when using the gridline calculation for the X axis
  public required init(frameHeight: Double, frameWidth: Double, offSet: Double, arrayCount: Double){
    self.offSet = offSet
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.arrayCount = arrayCount
  }
  
  func yGridlineStartPoint(i: Int) -> CGPoint {
    let frameScale = (frameHeight - currentFrame.distanceFromBottom - 10) / Double(currentFrame.yAxisGridlinesCount)
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let actualValue = frameScale * Double(i)
    let yStartPoint = CGPoint(x: offSet, y: yAxisPadding - actualValue)
    
    return yStartPoint
  }
  
  func yGridlineEndPoint(i: Int) -> CGPoint {
    let frameScale = (frameHeight - currentFrame.distanceFromBottom - 10) / Double(currentFrame.yAxisGridlinesCount)
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let xAxisPadding = frameWidth - offSet
    let actualValue = frameScale * Double(i)
    
    let yEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue)
    
    return yEndPoint
  }
  
  func xGridlineStartPoint(distanceIncrement: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSet * 2)
    var increment = 0.0
    if arrayCount < 6 {
      increment = spaceLeft / (arrayCount - 1)
    } else {
      increment = spaceLeft / 6
    }
    let xValue = offSet + (increment * Double(distanceIncrement))
    let xStartPoint = CGPoint(x: xValue, y: 10)
    return xStartPoint
  }
  
  
  func xGridlineEndPoint(distanceIncrement: Int) -> CGPoint {
    let yAxisPadding = frameHeight - currentFrame.distanceFromBottom
    let spaceLeft = frameWidth - (offSet * 2)
    var increment = 0.0
    if arrayCount < 6 {
      increment = spaceLeft / (arrayCount - 1)
    } else {
      increment = spaceLeft / 6
    }
    let xValue = offSet + (increment * Double(distanceIncrement))
    let yEndPoint = CGPoint(x: xValue, y: yAxisPadding)
    return yEndPoint
    
  }
  
  
  
  
}
