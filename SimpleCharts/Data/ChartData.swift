//
//  ChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class ChartData {
  
  public var array: [Double]
  public var name: String
  
  
  required public init(dataset: [Double], datasetName: String) {
    self.array = dataset
    self.name = datasetName
  }
  
  required public init() {
    self.array = []
    self.name = "init"
  }

}
