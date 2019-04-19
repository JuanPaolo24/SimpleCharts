//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 08/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartView: BarChartRenderer {
  
  
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
  
  
  /// Enables the axis label customisation (Default = false)
  open var enableAxisCustomisation = false
  
  /// Set X Axis label (Pass in a string array with the same number of labels as the data set)
  open var setXAxisLabel:[String] = []
  
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
  
  /// Graph off set on the top (Default = 20)
  open var offSetTop:Double = 20.0
  

  /// An instance of the xAxis to provide customisation through this
  open var xAxis:xAxisConfiguration = xAxisConfiguration()
  
  /// An instance of the yAxis to provide customisation through this
  open var yAxis:yAxisConfiguration = yAxisConfiguration()
  
  
  public var data = BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test")])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override open func layoutSubviews() {
    //
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
      renderVerticalBarGraph(context: context, landscapePadding: scale, currentOrientation: .landscape)
    } else {
      renderVerticalBarGraph(context: context, landscapePadding: 1.0, currentOrientation: .portrait)
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
  
  
  func barGraph(context: CGContext, array: [[Double]], data: BarChartDataSet, max: Double, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
    for (i, value) in array.enumerated() {
      drawVerticalBarGraph(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue,data: data.array[i], overallCount: Double(i), arrayCount: Double(array.count), offSet: offSet)
    }
  }

  func renderVerticalBarGraph(context: CGContext, landscapePadding: Double, currentOrientation: orientation) {
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    
    let axis = AxisRenderer(frame: self.frame)
    
    var maxValue = 0.0
    var minValue = 0.0
    
    let actualMax = helper.processMultipleArrays(array: convertedData)
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    let height = Double(frame.size.height)
    let width = Double(frame.size.width)
    
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
     let generalCalculationHandler = GeneralGraphCalculation(frameHeight: height, frameWidth: width, arrayCount: Double(arrayCount), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    
    legend.legendPadding(currentOrientation: currentOrientation)
    
    axisBase(context: context, offSet: offSet)
    context.saveGState()
    barxAxisGridlines(context: context, arrayCount: arrayCount, offSet: offSet)
    yAxisGridlines(context: context, calc: generalCalculationHandler, gridlineCount: yAxis.setGridlineCount)
    context.restoreGState()
    barGraph(context: context, array: convertedData, data: data, max: maxValue, landscapePadding: landscapePadding)
    
    
    if yAxis.yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, minValue: minValue, axisInverse: enableYAxisInverse, offSet: offSet, gridlineCount: yAxis.setGridlineCount)
    }
    
    if xAxis.xAxisVisibility == true {
      if enableAxisCustomisation == true {
        axis.customiseBarGraphxAxis(context: context, arrayCount: arrayCount, label: setXAxisLabel, offSet: offSet)
      } else {
        axis.barGraphxAxis(context: context, arrayCount: arrayCount, offSet: offSet)
      }
      
    }
    
    if legendVisibility == true {
      legend.renderBarChartLegend(context: context, arrays: data.array, position: legendPosition, customX: customXlegend, customY: customYlegend)
    }
    
  }
  
}
