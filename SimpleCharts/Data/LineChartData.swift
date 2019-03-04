//
//  ChartData.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartData: ChartData {
  
  required public init(dataset: [Double], datasetName: String) {
    super.init(dataset: dataset, datasetName: datasetName)
  }
  
  //Line Chart
  /// Enable the circle points
  open var enableCirclePoint = true
  
  /// Enable the line
  open var enableLine = true
  
  /// Set Circle Point (Line Graph) colour
  open var setCirclePointColour = UIColor.black.cgColor
  
  /// Set Line Point (Line Graph) colour
  open var setLinePointColour = UIColor.black.cgColor
  
  /// Set Circle Point Radius (Default = 3)
  open var setCirclePointRadius = CGFloat(3.0)
  
  /// Set Line Point Width (Default = 1)
  open var setLineWidth = CGFloat(1.0)
  
  /// Enable the data point labels (Default = True)
  open var enableDataPointLabel = true
  
  /// Set the intensity of the bezier curve (Default 0.2)
  open var setBezierCurveIntensity = 0.2
  
  
}
