//
//  CombinedChartDataSet.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 27/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class CombinedChartDataSet {
  
  public let array: [CombinedChartData]
  
  required public init(dataset: [CombinedChartData]) {
    self.array = dataset
  }
  
  
  
}
