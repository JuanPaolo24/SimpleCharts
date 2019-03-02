//
//  BarChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 11/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartData: ChartData {
  
  required public init(dataset: [Double], datasetName: String) {
    super.init(dataset: dataset, datasetName: datasetName)
  }
  
  //Bar Chart
  /// Set Bar Graph inside colour (Default = Black)
  open var setBarGraphFillColour = UIColor.black.cgColor
  
  /// Set Bar Graph outline colour (Default = Black)
  open var setBarGraphStrokeColour = UIColor.black.cgColor
  
  /// Set Bar Graph Line Width (Default = 1.0)
  open var setBarGraphLineWidth = CGFloat(1.0)

  
}