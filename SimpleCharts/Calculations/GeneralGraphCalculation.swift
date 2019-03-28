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
  private var offSet:offset
  private var yAxisGridlineCount: Double
  private var xAxisGridlineCount: Double
  

  public required init(frameHeight: Double, frameWidth: Double, arrayCount: Double, offSet: offset, yAxisGridlineCount: Double, xAxisGridlineCount: Double){
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.arrayCount = arrayCount
    self.offSet = offSet
    self.yAxisGridlineCount = yAxisGridlineCount
    self.xAxisGridlineCount = xAxisGridlineCount
  }

  
  func yGridlinePoint(i: Int, destination: position) -> CGPoint {
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
  
  func xGridlinePoint(distanceIncrement: Int, destination: position) -> CGPoint {
    let yAxisPadding = frameHeight - offSet.bottom
    let spaceLeft = frameWidth - (offSet.left + offSet.right)
    var increment = 0.0
    if arrayCount < xAxisGridlineCount {
      increment = spaceLeft / (arrayCount - 1)
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
  
}
