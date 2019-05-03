//
//  yAxisConfiguration.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 17/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class yAxisConfiguration {
  
  /// Y axis left labels visibility (Default = True)
  open var leftYAxisVisibility: Bool = true
  
  /// Y axis right label visibility (Default = True)
  open var rightYAxisVisibility: Bool = true
  
  /// If you want to just set a custom maximum value then use this variable along with the gridline count to set the preferred number of gridline.
  open var setYAxisMaximumValue: Double = 0.0
  
  /// Set this along with maximum to provide a custom Y axis label
  open var setYAxisMinimumValue: Double = 0.0
  
  /// Makes the Y axis inverse (Default = False)
  open var enableYAxisInverse: Bool = false
  
  /// Number of gridlines (Default = 6)
  open var setGridlineCount:Double = 6

  
  /// (Only works on horizontal bar graph) Accepts an array of string which will be used for the X axis label. Does not apply to horizontal bar graph
  open var setYAxisLabel: [String] = []
  
}
