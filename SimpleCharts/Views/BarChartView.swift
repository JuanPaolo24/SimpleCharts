//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 08/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartView: ChartRenderer {
  
  //Axis
  /// X axis labels visibility (Default = True)
  open var xAxisVisibility = true
  
  /// Returns true if X Axis label is visible
  open var isxAxisLabelVisible: Bool { get {return xAxisVisibility} }
  
  /// Y axis labels visibility (Default = True)
  open var yAxisVisibility = true
  
  /// Returns true if Y Axis label is visible
  open var isyAxisLabelVisible: Bool { get {return yAxisVisibility} }
  
  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Returns true if legend is visible
  open var isLegendVisible: Bool { get {return legendVisibility} }
  
  
  /// Enables the axis label customisation (Default = false)
  open var enableAxisCustomisation = false
  
  /// Set X Axis label (Pass in a string array with the same number of labels as the data set)
  open var setXAxisLabel:[String] = []
  
  /// Makes the Y axis inverse (Default = False)
  open var enableYAxisInverse = false
  
  /// Returns true if Y Axis is inverse
  open var isyAxisInverse: Bool { get {return enableYAxisInverse}}
  
  
  public var data = BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test")])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    if UIDevice.current.orientation.isLandscape {
      renderVerticalBarGraph(context: context, padding: 70)
    } else {
      renderVerticalBarGraph(context: context, padding: 31)
    }
    
  }
  

  func renderVerticalBarGraph(context: CGContext, padding: Double) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    xAxisBase(context: context, offSetTop: 10, offSetBottom: 62, offSetLeft: 31, offSetRight: 31)
    yAxisBase(context: context, offSetTop: 10, offSetBottom: 62, offSetLeft: 31, offSetRight: 31)
    barGraph(context: context, array: convertedData,initialValue: padding, graphType: "Vertical", data: data, max: maxValue)
    barxAxisGridlines(context: context, arrayCount: arrayCount, initialValue: padding)
    
    if yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, axisInverse: enableYAxisInverse, offSetTop: 10, offSetBottom: 62, offSetLeft: 31 - 10, offSetRight: 31)
    }
    
    if xAxisVisibility == true {
      if enableAxisCustomisation == true {
        axis.customiseBarGraphxAxis(context: context, arrayCount: arrayCount, initialValue: padding, label: setXAxisLabel)
      } else {
        axis.barGraphxAxis(context: context, arrayCount: arrayCount, initialValue: padding)
      }
      
    }
    
    if legendVisibility == true {
      legend.renderBarChartLegend(context: context, arrays: data.array)
    }
    
  }
  
}
