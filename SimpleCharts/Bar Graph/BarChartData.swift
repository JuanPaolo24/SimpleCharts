//
//  BarChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 11/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartData: DataSetRenderer {
  
  public var dataset: [Double]
  
  public override init(array: [Double]) {
    self.dataset = array
    super.init(array: array)
  }
  
  public func returnData() -> [Double] {
    return dataset
  }
  
  
  
}
