//
//  CombinedChartDataSet.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 27/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class CombinedChartDataSet {
  
  public let lineData: LineChartDataSet
  public let barData: BarChartDataSet
  
  required public init(lineData: LineChartDataSet, barData: BarChartDataSet) {
    self.lineData = lineData
    self.barData = barData
  }
  
}
