//
//  BarChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 11/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartData: DataSetHandler {
  
  
  public required init(dataset: [[Double]]) {
    super.init(dataset: dataset)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
