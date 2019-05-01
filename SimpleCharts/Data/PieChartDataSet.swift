//
//  PieChartDataSet.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class PieChartDataSet {
  
  public let array: [PieChartData]
  
  required public init(dataset: [PieChartData]) {
    self.array = dataset
  }
  
  required public init() {
    self.array = [PieChartData(color: UIColor.white, value: 0, name: "")]
  }
}
