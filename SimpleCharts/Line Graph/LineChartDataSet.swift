//
//  LineChartDataSet.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 20/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartDataSet {
  
  public let array: [LineChartData]
  
  required public init(dataset: [LineChartData]) {
    self.array = dataset
  }
  
  
  
}
