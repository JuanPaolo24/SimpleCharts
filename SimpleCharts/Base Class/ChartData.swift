//
//  ChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

// Will be a class that will serve as a base class for Bar and Line Chart Data
open class ChartData {
  
  public var array: [Double]
  public var name: String
  
  
  required public init(dataset: [Double], datasetName: String) {
    self.array = dataset
    self.name = datasetName
  }

}
