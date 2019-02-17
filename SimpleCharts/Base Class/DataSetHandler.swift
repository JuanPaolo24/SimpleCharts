//
//  DataSetRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class DataSetHandler: UIView {
  
  
  // This class will ensure that any data entered will be accepted and converted to double
  // Also will render the data set into the view 
  
  let array: [[Double]]
  
  required public init(dataset: [[Double]]) {
    self.array = dataset
    super.init(frame: CGRect.zero)
  }
  
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
