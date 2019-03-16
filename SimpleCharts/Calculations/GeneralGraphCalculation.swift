//
//  GeneralGraphCalculation.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 01/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class GeneralGraphCalculation {
  
  private var frameWidth: Double
  private var frameHeight: Double
  private var arrayCount: Double
  
  
  private var offSetTop: Double
  private var offSetBottom: Double
  private var offSetLeft: Double
  private var offSetRight: Double
  

  public required init(frameHeight: Double, frameWidth: Double, arrayCount: Double, offSetTop: Double, offSetBottom: Double, offSetLeft: Double, offSetRight: Double){
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.arrayCount = arrayCount

    self.offSetTop = offSetTop
    self.offSetBottom = offSetBottom
    self.offSetRight = offSetRight
    self.offSetLeft = offSetLeft
  }

  
  
  
  func yGridlineStartPoint(i: Int) -> CGPoint {
    let frameScale = (frameHeight - offSetBottom - offSetTop) / Double(currentFrame.yAxisGridlinesCount)
    let yAxisPadding = frameHeight - offSetBottom
    let actualValue = frameScale * Double(i)
    let yStartPoint = CGPoint(x: offSetLeft, y: yAxisPadding - actualValue)
    
    return yStartPoint
  }
  
  func yGridlineEndPoint(i: Int) -> CGPoint {
    let frameScale = (frameHeight - offSetBottom - offSetTop) / Double(currentFrame.yAxisGridlinesCount)
    let yAxisPadding = frameHeight - offSetBottom
    let xAxisPadding = frameWidth - offSetRight
    let actualValue = frameScale * Double(i)
    
    let yEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue)
    
    return yEndPoint
  }
  
  func xGridlineStartPoint(distanceIncrement: Int) -> CGPoint {
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    var increment = 0.0
    if arrayCount < 6 {
      increment = spaceLeft / (arrayCount - 1)
    } else {
      increment = spaceLeft / 6
    }
    let xValue = offSetLeft + (increment * Double(distanceIncrement))
    let xStartPoint = CGPoint(x: xValue, y: offSetTop)
    return xStartPoint
  }
  
  
  func xGridlineEndPoint(distanceIncrement: Int) -> CGPoint {
    let yAxisPadding = frameHeight - offSetBottom
    let spaceLeft = frameWidth - (offSetLeft + offSetRight)
    var increment = 0.0
    if arrayCount < 6 {
      increment = spaceLeft / (arrayCount - 1)
    } else {
      increment = spaceLeft / 6
    }
    let xValue = offSetLeft + (increment * Double(distanceIncrement))
    let yEndPoint = CGPoint(x: xValue, y: yAxisPadding)
    return yEndPoint
    
  }
  
  
  
  
}
