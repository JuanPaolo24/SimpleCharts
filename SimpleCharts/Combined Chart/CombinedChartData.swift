//
//  CombinedChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class CombinedChartData {
  
  public var lineData: LineChartData
  public var barData: BarChartData
  
  
  required public init(lineData: LineChartData, barData: BarChartData) {
    self.lineData = lineData
    self.barData = barData
  }
  
}
