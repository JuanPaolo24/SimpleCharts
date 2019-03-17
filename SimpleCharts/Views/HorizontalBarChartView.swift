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
  
  /// Graph off set on the left (Default = 31)
  open var offSetLeft:Double = 31.0
  
  /// Graph off set on the right (Default = 31)
  open var offSetRight:Double = 31.0
  
  /// Graph off set on the bottom (Default = 62)
  open var offSetBottom:Double = 62.0
  
  /// Graph off set on the top (Default = 20)
  open var offSetTop:Double = 10.0
  
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
    
    let scale = 70.0/31.0
    
    if UIDevice.current.orientation.isLandscape {
      renderHorizontalBarGraph(context: context, landscapePadding: scale)
    } else {
      renderHorizontalBarGraph(context: context, landscapePadding: 1.0)
    }
    
  }
  
  func barGraph(context: CGContext, array: [[Double]], data: BarChartDataSet, max: Double, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawHorizontalBarGraph(context: context, array: value, maxValue: max, data: data.array[i], offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
 
  func renderHorizontalBarGraph(context: CGContext, landscapePadding: Double) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    xAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: offSetLeft, offSetRight: offSetRight)
    yAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: offSetLeft, offSetRight: offSetRight)
    barGraph(context: context, array: convertedData, data: data, max: maxValue, landscapePadding: landscapePadding)
    horizontalBarGraphXGridlines(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: offSetLeft, offSetRight: offSetRight)
    horizontalBarGraphYGridlines(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: offSetLeft, offSetRight: offSetRight)
    
    if yAxisVisibility == true {
      axis.horizontalBarGraphYAxis(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: offSetLeft, offSetRight: offSetRight)
    }
    
    if xAxisVisibility == true {
      axis.horizontalBarGraphXAxis(context: context, maxValue: maxValue, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: offSetLeft, offSetRight: offSetRight)
    }
    
//    if legendVisibility == true {
//      legend.renderBarChartLegend(context: context, arrays: data.array)
//    }
    
  }
  
}
