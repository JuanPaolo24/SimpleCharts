//
//  HorizontalBarChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 25/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class HorizontalBarChartView: ChartRenderer {
  
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
  
  public var data = BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test")])
  
  override public init(frame: CGRect) {
    self.data = BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test")])
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
      renderHorizontalBarGraph(context: context, padding: 70)
    } else {
      renderHorizontalBarGraph(context: context, padding: 31)
    }
    
  }
  
  func renderHorizontalBarGraph(context: CGContext, padding: Double) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    barGraph(context: context, array: convertedData, initialValue: padding, graphType: "Horizontal", data: data, max: maxValue)
    horizontalBarGraphXGridlines(context: context, initialValue: padding)
    horizontalBarGraphYGridlines(context: context, arrayCount: arrayCount, padding: padding)
    
    if yAxisVisibility == true {
      axis.horizontalBarGraphYAxis(context: context, arrayCount: arrayCount, padding: padding)
    }
    
    if xAxisVisibility == true {
      axis.horizontalBarGraphXAxis(context: context, maxValue: maxValue, initialValue: padding)
    }
    
    if legendVisibility == true {
      legend.renderBarChartLegend(context: context, arrays: data.array)
    }
    
  }
  
}
