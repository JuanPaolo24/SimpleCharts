//
//  yAxisConfiguration.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 17/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class yAxisConfiguration {
  
  /// Y axis labels visibility (Default = True)
  open var yAxisVisibility = true
  
  /// If you want to just set a custom maximum value then use this variable along with the gridline count to set the preferred number of gridline. 
  open var setYAxisMaximumValue: Double = 0.0
  
  /// Set this along with maximum to provide a custom Y axis label
  open var setYAxisMinimumValue: Double = 0.0
  
  /// Makes the Y axis inverse (Default = False)
  open var enableYAxisInverse = false
  
  /// Returns true if Y Axis is inverse
  open var isyAxisInverse: Bool { get {return enableYAxisInverse}}
  
  /// Number of gridlines (Default = 6)
  open var setGridlineCount:Double = 6
}
