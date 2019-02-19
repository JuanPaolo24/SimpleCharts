//
//  DataSetRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class DataSetHandler {
  
  
  // This class will ensure that any data entered will be accepted and converted to double
  // Also will render the data set into the view 
  
  public let array: [ChartData]

  init(dataset: [ChartData]) {
    self.array = dataset
  }
  

  
}
