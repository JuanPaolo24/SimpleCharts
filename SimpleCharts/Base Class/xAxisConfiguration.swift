//
//  xAxis.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 17/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

@IBDesignable
open class xAxisConfiguration {
  
  //Axis
  /// X axis labels visibility (Default = True)
  open var xAxisVisibility: Bool = true
  
  /// Number of gridlines (Default = 6)
  open var setGridlineCount:Double = 6
  
  /// Accepts an array of string which will be used for the X axis label. Does not apply to horizontal bar graph
  open var setXAxisLabel: [String] = []
  
}
