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
  
  required public init() {
    super.init(dataset: [], datasetName: "empty")
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
  
  /// Set the graph colour both the circle point and the line
  open var setLineGraphColour = UIColor(red:0.67, green:0.92, blue:1.00, alpha:1.0).cgColor
  
  /// Set Circle Point Radius (Default = 5)
  open var setCirclePointRadius: CGFloat = 5.0
  
  /// Set Line Point Width (Default = 1)
  open var setLineWidth: CGFloat = 1.0
  
  /// Enable the data point labels (Default = True)
  open var enableDataPointLabel = false
  
  /// Returns true if data point label is visible
  open var isDataLabelVisible: Bool { get {return enableDataPointLabel} }
  
  /// Set the Text Label Point for line graphs (Default = 8.0)
  open var setTextLabelFont: CGFloat = 8.0
  
  /// Set the Text Label Color for line graphs (Default = Black)
  open var setTextLabelColour: UIColor = UIColor.black
  
  /// Set the intensity of the bezier curve (Default 0.2)
  open var setBezierCurveIntensity = 0.2
  


  // This section is graph fill customisation //
  
  /// Enable Graph Fill (Default = False)
  open var enableGraphFill = false
  
  /// Returns true if graph fill is visible
  open var isGraphFillEnabled: Bool {get {return enableGraphFill}}
  
  /// The type of fill the graph will have
  open var fillType: filltype = .normalFill
  
  /// Array of colours for the gradient
  open var gradientFillColours: [UIColor] = [UIColor.blue, UIColor.red]
  
  
  /// Graph Fill Colour for normal fill configuration (Default = Clear)
  open var setGraphFill: UIColor = UIColor.clear
  
  /// Fill alpha/transparency (Default = 0.33)
  open var setFillAlpha: CGFloat = 0.33
  
  
  
  /// Animation Configuration
  
  //Animation duration (Default = 2)
  open var setAnimationDuration: CFTimeInterval = 3
  
  
  /// Legend Configuration (Default = Rectangle)
  open var setLegendShape: legendShape = .rectangle
  
}
