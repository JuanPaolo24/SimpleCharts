//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: ChartRenderer {
  
  
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
  
  /// Enables the axis label customisation, if it is false then the max value of the data set will be taken and multiplied by 20% (Default = false)
  open var enableAxisCustomisation = false
  
  /// The Y axis interval (Default = 25) (Minimum Value = Max value of the data set / 6) ie MaxValue = 150 then minimum value = 25
  open var setYAxisInterval:Double = 25.0
  
  /// Makes the Y axis inverse (Default = False)
  open var enableYAxisInverse = false
  
  /// Returns true if Y Axis is inverse
  open var isyAxisInverse: Bool { get {return enableYAxisInverse}}
  
  
  /// Graph off set on the left (Default = 31)
  open var offSetLeft:Double = 31.0
  
  /// Graph off set on the right (Default = 31)
  open var offSetRight:Double = 31.0
  
  /// Graph off set on the bottom (Default = 62)
  open var offSetBottom:Double = 62.0
  
  /// Graph off set on the top (Default = 10)
  open var offSetTop:Double = 10.0
  
  /// Line type
  open var enableBezierCurve = true
  
  
  public var data = LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")])
  
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
    let scale = 70.0/31.0
    
    if enableBezierCurve {
      if UIDevice.current.orientation.isLandscape {
        renderBezierGraph(context: context, landscapePadding: scale)
      } else {
        renderBezierGraph(context: context, landscapePadding: 1.0)
      }
    } else {
      if UIDevice.current.orientation.isLandscape {
        renderLineGraph(context: context, landscapePadding: scale) //70
      } else {
        renderLineGraph(context: context, landscapePadding: 1.0) //31
      }
      
    }
    
    
  }
  
  /// Renders a line graph
  func lineGraph(context: CGContext, array: [[Double]], initialValue: Double, max: Double, data: LineChartDataSet, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawLineGraph(context: context, array: value, maxValue: max, source: data.array[i], forCombined: false, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
  
  
  func renderLineGraph(context: CGContext, landscapePadding: Double) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    var maxValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = setYAxisInterval * 6
    } else {
      maxValue = helper.processMultipleArrays(array: convertedData)
    }
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    xAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    yAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    lineGraph(context: context, array: convertedData, initialValue: 0, max: maxValue, data: data, landscapePadding: landscapePadding)
    yAxisGridlines(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    xAxisGridlines(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    
    if yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, axisInverse: enableYAxisInverse, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset - 10, offSetRight: paddedRightOffset)
    }
  
    if xAxisVisibility == true {
      axis.xAxis(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
    
    if legendVisibility == true {
      legend.renderLineChartLegend(context: context, arrays: data.array)
    }
    
  }
  
  /// Renders a line graph
  func lineBezierGraph(context: CGContext, array: [[Double]], data: LineChartDataSet, landscapePadding: Double) {
    let helper = HelperFunctions()
    let max = helper.processMultipleArrays(array: array)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawBezierCurve(context: context, array: value, maxValue: max, source: data.array[i], offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
  

  func renderBezierGraph(context: CGContext, landscapePadding: Double) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
   
    xAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    yAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    lineBezierGraph(context: context, array: convertedData, data: data, landscapePadding: landscapePadding)
    yAxisGridlines(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    xAxisGridlines(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    axis.yAxis(context: context, maxValue: maxValue, axisInverse: enableYAxisInverse, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset - 10, offSetRight: paddedRightOffset)
    axis.xAxis(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    legend.renderLineChartLegend(context: context, arrays: data.array)
    
  }
  

}



