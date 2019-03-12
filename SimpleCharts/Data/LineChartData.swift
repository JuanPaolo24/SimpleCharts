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
  /// Make the circle points on the line graph visible (Default = True)
  open var enableCirclePointVisibility = true
  
  /// Returns true if circle point is visible
  open var isCirclePointVisible: Bool { get {return enableCirclePointVisibility} }
  
  /// Make the line graphs line visible (Default = True)
  open var enableLineVisibility = true
  
  /// Returns true if line is visible
  open var isLineVisible: Bool { get {return enableLineVisibility} }
  
  /// Set Circle Point (Line Graph) colour
  open var setCirclePointColour = UIColor.black.cgColor
  
  /// Set Line (Line Graph) colour
  open var setLineColour = UIColor.black.cgColor
  
  /// Set Circle Point Radius (Default = 3)
  open var setCirclePointRadius: CGFloat = 3.0
  
  /// Set Line Point Width (Default = 1)
  open var setLineWidth: CGFloat = 1.0
  
  /// Enable the data point labels (Default = True)
  open var enableDataPointLabel = true
  
  /// Returns true if data point label is visible
  open var isDataLabelVisible: Bool { get {return enableDataPointLabel} }
  
  /// Set the Text Label Point for line graphs (Default = 8.0)
  open var setTextLabelFont: CGFloat = 8.0
  
  /// Set the Text Label Color for line graphs (Default = Black)
  open var setTextLabelColour: UIColor = UIColor.black
  
  /// Set the intensity of the bezier curve (Default 0.2)
  open var setBezierCurveIntensity = 0.2
  
  /// Enable Graph Fill (Default = False)
  open var enableGraphFill = false
  
  /// Returns true if graph fill is visible
  open var isGraphFillEnabled: Bool {get {return enableGraphFill}}
  
}
