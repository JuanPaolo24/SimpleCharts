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
  open var enableCirclePointVisibility:Bool = true
  
  /// Make the line graphs line visible (Default = True)
  open var enableLineVisibility:Bool = true
  
  /// Set the graph color both the circle point and the line
  open var setLineGraphColor: UIColor = UIColor(red:0.67, green:0.92, blue:1.00, alpha:1.0)
  
  /// Set Circle Point Radius (Default = 5)
  open var setCirclePointRadius: CGFloat = 5.0
  
  /// Set Line Width (Default = 1)
  open var setLineWidth: CGFloat = 1.0
  
  /// Enable the data point labels (Default = false)
  open var enableDataPointLabel:Bool = false
  
  /// Set the Text Label Point for line graphs (Default = 8.0)
  open var setTextLabelFontSize: CGFloat = 8.0
  
  /// Set the Text Label Color for line graphs (Default = Black)
  open var setTextLabelColor: UIColor = UIColor.black
  
  /// Set the intensity of the bezier curve (Default 0.2)
  open var setBezierCurveIntensity:Double = 0.2
  


  // This section is graph fill customisation //
  
  /// Enable Graph Fill (Default = False)
  open var enableGraphFill:Bool = false
  
  /// The type of fill the graph will have (Default = normalFill)
  open var fillType: filltype = .normalFill
  
  /// Array of colors for the gradient (Default = blue, red)
  open var gradientFillColors: [UIColor] = [UIColor.blue, UIColor.red]
  
  
  /// Graph Fill Color for normal fill configuration (Default = Blue)
  open var setGraphFill: UIColor = UIColor(red:0.67, green:0.92, blue:1.00, alpha:1.0)
  
  /// Fill alpha/transparency (Default = 0.33)
  open var setFillAlpha: CGFloat = 0.33
  
  
  
  /// Animation Configuration
  
  //Animation duration (Default = 3)
  open var setAnimationDuration: CFTimeInterval = 3
  
  
  /// Legend Configuration (Default = Rectangle)
  open var setLegendShape: legendShape = .rectangle
  
}
