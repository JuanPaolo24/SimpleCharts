//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: ChartRenderer {
  

  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Returns true if legend is visible
  open var isLegendVisible: Bool { get {return legendVisibility} }
  
  
  /// Legend Position (Default = bottom)
  open var legendPosition: legendPlacing = .bottom
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  
  /// Enables the axis label customisation, if it is false then the max value of the data set will be taken and multiplied by 20% (Default = false)
  open var enableAxisCustomisation = false
  

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
    
    changeOffset(position: legendPosition)
    
    let scale = 70.0/31.0
    
    if enableBezierCurve {
      if UIDevice.current.orientation.isLandscape {
        renderBezierGraph(context: context, landscapePadding: scale, currentOrientation: .landscape)
      } else {
        renderBezierGraph(context: context, landscapePadding: 1.0, currentOrientation: .portrait)
      }
    } else {
      if UIDevice.current.orientation.isLandscape {
        renderLineGraph(context: context, landscapePadding: scale, currentOrientation: .landscape) //70
      } else {
        renderLineGraph(context: context, landscapePadding: 1.0, currentOrientation: .portrait) //31
      }
      
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
  func lineGraph(context: CGContext, array: [[Double]], initialValue: Double, max: Double, data: LineChartDataSet, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawLineGraph(context: context, array: value, maxValue: max, source: data.array[i], forCombined: false, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
  
  // Takes all the components and renders it together
  func renderLineGraph(context: CGContext, landscapePadding: Double, currentOrientation: orientation) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    var maxValue = 0.0
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    legend.legendPadding(currentOrientation: currentOrientation)
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisInterval * 6
    } else {
      maxValue = helper.processMultipleArrays(array: convertedData)
    }
    
    xAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    yAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    lineGraph(context: context, array: convertedData, initialValue: 0, max: maxValue, data: data, landscapePadding: landscapePadding)
    yAxisGridlines(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    xAxisGridlines(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    
    if yAxis.yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, axisInverse: yAxis.enableYAxisInverse, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset - 10, offSetRight: paddedRightOffset)
    }
    
    if xAxis.xAxisVisibility == true {
      axis.xAxis(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  
    if legendVisibility == true {
      legend.renderLineChartLegend(context: context, arrays: data.array, position: legendPosition, customX: customXlegend, customY: customYlegend)
    }
    
  }
  
  /// Renders a line graph
  func lineBezierGraph(context: CGContext, array: [[Double]], data: LineChartDataSet, max: Double, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    for (i, value) in array.enumerated() {
      drawBezierCurve(context: context, array: value, maxValue: max, source: data.array[i], offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
  }
  

  func renderBezierGraph(context: CGContext, landscapePadding: Double, currentOrientation: orientation) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    
    legend.legendPadding(currentOrientation: currentOrientation)
    
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    
    var maxValue = 0.0
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisInterval * 6
    } else {
      maxValue = helper.processMultipleArrays(array: convertedData)
    }
    
    xAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    yAxisBase(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    lineBezierGraph(context: context, array: convertedData, data: data, max: maxValue, landscapePadding: landscapePadding)
    yAxisGridlines(context: context, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    xAxisGridlines(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    
    if yAxis.yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, axisInverse: yAxis.enableYAxisInverse, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset - 10, offSetRight: paddedRightOffset)
    }
    
    if xAxis.xAxisVisibility == true {
      axis.xAxis(context: context, arrayCount: arrayCount, offSetTop: offSetTop, offSetBottom: offSetBottom, offSetLeft: paddedLeftOffset, offSetRight: paddedRightOffset)
    }
    
    if legendVisibility == true {
      legend.renderLineChartLegend(context: context, arrays: data.array, position: legendPosition, customX: customXlegend, customY: customYlegend)
    }
    
    
    
  }
  

}



