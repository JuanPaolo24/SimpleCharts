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
  
  required public init() {
    super.init(dataset: [], datasetName: "init")
  }
  
  //Bar Chart
  /// Set Bar Graph inside color (Default = UIColor(red:0.68, green:0.92, blue:1.00, alpha:1.0))
  open var setBarGraphFillColor: UIColor = UIColor(red:0.68, green:0.92, blue:1.00, alpha:1.0)
  
  /// Set Bar Graph Line Width (Default = 1.0)
  open var setBarGraphLineWidth = CGFloat(1.0)
  
  /// Set the Text Label Point for bar graphs (Default = 8.0)
  open var setTextLabelFont: CGFloat = 8.0
  
  /// Set the Text Label Color for bar graphs (Default = Black)
  open var setTextLabelColor: UIColor = UIColor.black
  
  /// Enable the data point labels (Default = false)
  open var enableDataPointLabel:Bool = false

  
  /// Animation Configuration
  
  //Animation duration (Default = 3)
  open var setAnimationDuration: CFTimeInterval = 3
  
  /// Legend Configuration (Default = Rectangle)
  open var setLegendShape: legendShape = .rectangle
  
}
