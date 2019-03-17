//
//  CombinedChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class CombinedChartView: ChartRenderer {
  

  /// Legend Position (Default = bottom)
  open var legendPosition: legendPlacing = .bottom
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  
  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Graph off set on the left (Default = 31)
  open var offSetLeft:Double = 31.0
  
  /// Graph off set on the right (Default = 31)
  open var offSetRight:Double = 31.0
  
  /// Graph off set on the bottom (Default = 62)
  open var offSetBottom:Double = 62.0
  
  /// Graph off set on the top (Default = 20)
  open var offSetTop:Double = 20.0
  
  /// An instance of the xAxis to provide customisation through this
  open var xAxis:xAxisConfiguration = xAxisConfiguration()
  
  /// An instance of the yAxis to provide customisation through this
  open var yAxis:yAxisConfiguration = yAxisConfiguration()
  
  
  /// Add the data source
  public var data = CombinedChartDataSet(lineData: LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")]), barData: BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test2")]))
  
  
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
    
    changeOffset(position: legendPosition)
    
    let scale = 70.0/31.0
    
    if UIDevice.current.orientation.isLandscape {
      renderCombinedChart(context: context, landscapePadding: scale, currentOrientation: .landscape)
    } else {
      renderCombinedChart(context: context, landscapePadding: 1.0, currentOrientation: .portrait)
    }
    
    
  }
  
  // Changes offset configuration based on the position of the legend
  // This is for the default configuration
  func changeOffset(position: legendPlacing) {
    switch position {
    case .bottom:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 62.0
      offSetTop = 20.0
    case .top:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 31.0
      offSetTop = 50.0
    case .right:
      offSetLeft = 31.0
      offSetRight = 70.0
      offSetBottom = 31.0
      offSetTop = 20.0
    case .left:
      offSetLeft = 70.0
      offSetRight = 31.0
      offSetBottom = 31.0
      offSetTop = 20.0
    case .custom:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 62.0
      offSetTop = 20.0
    }
    
  }
  
  
  /// Renders a line graph
  func lineGraph(context: CGContext, array: [[Double]], max: Double, data: LineChartDataSet, forCombined: Bool, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawLineGraph(context: context, array: value, maxValue: max, source: data.array[i], forCombined: forCombined, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
  
  
  /// Renders a line graph
  func lineBezierGraph(context: CGContext, array: [[Double]], data: LineChartDataSet) {
    let helper = HelperFunctions()
    let max = helper.processMultipleArrays(array: array)
    
    
    for (i, value) in array.enumerated() {
      drawBezierCurve(context: context, array: value, maxValue: max, source: data.array[i], offSetTop: 10, offSetBottom: 62, offSetLeft: 31, offSetRight: 31)
    }
  }
  
  func barGraph(context: CGContext, array: [[Double]], data: BarChartDataSet, max: Double, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawVerticalBarGraph(context: context, array: value, maxValue: max, data: data.array[i], overallCount: Double(i), arrayCount: Double(array.count), offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
  
  
  
  func renderCombinedChart(context: CGContext, landscapePadding: Double, currentOrientation: orientation) {
    let helper = HelperFunctions()
    let axis = AxisRenderer(frame: self.frame)
    let legend = LegendRenderer(frame: self.frame)
    
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    let lineChartDataSet = data.lineData
    let barChartDataSet = data.barData
    
    let lineConvertedData = helper.convert(chartData: lineChartDataSet.array)
    let barConvertedData = helper.convert(chartData: barChartDataSet.array)
    
    let lineMaxValue = helper.processMultipleArrays(array: lineConvertedData)
    let barMaxValue = helper.processMultipleArrays(array: barConvertedData)
    let maxValue = max(lineMaxValue, barMaxValue)
    
    let lineArrayCount = helper.findArrayCountFrom(array: lineConvertedData)
    let barArrayCount = helper.findArrayCountFrom(array: barConvertedData)
    let arrayCount = max(lineArrayCount, barArrayCount)
    
    
    legend.legendPadding(currentOrientation: currentOrientation)
    
    xAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    yAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    barGraph(context: context, array: barConvertedData, data: barChartDataSet, max: maxValue, landscapePadding: landscapePadding)
    lineGraph(context: context, array: lineConvertedData, max: maxValue, data: lineChartDataSet, forCombined: true, landscapePadding: landscapePadding)
    yAxisGridlines(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    barxAxisGridlines(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    
    if yAxis.yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, axisInverse: yAxis.enableYAxisInverse, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset - 10, offSetRight: paddedRightOffset)
    }
    
    if xAxis.xAxisVisibility == true {
      axis.barGraphxAxis(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
    
    if legendVisibility == true {
      legend.renderCombinedChartLegend(context: context, data: data, position: legendPosition, customX: customXlegend, customY: customYlegend)
    }
    
  }
  
  
}
