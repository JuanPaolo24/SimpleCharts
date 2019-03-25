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
  
  /// The Y axis interval (Default = 25) (This is multiplied along with the gridline count to produce the maximum Y value so if you need any specific interval then modify the gridline count as well)
  open var setYAxisInterval:Double = 25.0
  
  /// Enable this to disable the custom or automatic calculation of the Y axis and just put a default max value to calculate the Y axis from
  open var enableMaximumValueCalculation:Bool = true
  
  /// If you want to just set a custom maximum value then use this variable along with the gridline count to set the preferred number of gridline. 
  open var setYAxisMaximumValue: Double = 0.0
  
  /// Makes the Y axis inverse (Default = False)
  open var enableYAxisInverse = false
  
  /// Returns true if Y Axis is inverse
  open var isyAxisInverse: Bool { get {return enableYAxisInverse}}
  
  /// Number of gridlines (Default = 6)
  open var setGridlineCount:Double = 6
}
