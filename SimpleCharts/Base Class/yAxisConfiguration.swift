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
  
  /// Returns true if Y Axis label is visible
  open var isyAxisLabelVisible: Bool { get {return yAxisVisibility} }
  
  /// The Y axis interval (Default = 25) (Minimum Value = Max value of the data set / 6) ie MaxValue = 150 then minimum value = 25
  open var setYAxisInterval:Double = 25.0
  
  /// Makes the Y axis inverse (Default = False)
  open var enableYAxisInverse = false
  
  /// Returns true if Y Axis is inverse
  open var isyAxisInverse: Bool { get {return enableYAxisInverse}}
  
  
}
