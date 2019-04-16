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
  
  /// Returns true if X Axis label is visible
  open var isxAxisLabelVisible: Bool { get {return xAxisVisibility} }
  
  /// Number of gridlines (Default = 6)
  open var setGridlineCount:Double = 6
  
}
