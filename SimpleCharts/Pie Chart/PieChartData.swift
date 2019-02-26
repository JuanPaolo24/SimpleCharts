//
//  PieChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class PieChartData {
  
  public var color: UIColor
  public var value: CGFloat
  public var name: String
  
  
  required public init(color: UIColor, value: CGFloat, name: String) {
    self.color = color
    self.value = value
    self.name = name
  }
  
  
}
