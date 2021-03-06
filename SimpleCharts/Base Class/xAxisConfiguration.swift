//
//  xAxis.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 17/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class xAxisConfiguration {
  
  //Line/Vertical/Combine
  /// X axis top labels visibility (Default = True)
  open var topXAxisVisibility: Bool = true
  
  /// X axis bottom label visibility (Default = True)
  open var bottomXAxisVisibility: Bool = true
  
  /// Number of gridlines (Default = 6)
  open var setGridlineCount:Double = 6
  
  /// Accepts an array of string which will be used for the X axis label. Does not apply to horizontal bar graph
  open var setXAxisLabel: [String] = []
  
  // Horizontal
  
  /// (Only works on horizontal bar graph) If you want to just set a custom maximum value then use this variable along with the gridline count to set the preferred number of gridline.
  open var setXAxisMaximumValue: Double = 0.0
  
  /// (Only works on horizontal bar graph) Set this along with maximum to provide a custom X axis label
  open var setXAxisMinimumValue: Double = 0.0
  
}
