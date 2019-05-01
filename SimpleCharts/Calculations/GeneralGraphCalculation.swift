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

  

  
}
