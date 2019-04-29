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
  
  
  /// Line type
  open var enableLineBezier = false
  
  /// Add the data source
  public var data = CombinedChartDataSet(lineData: LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")]), barData: BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test2")]))
  
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override open func layoutSubviews() {
    let scale = 70.0/31.0
    
    if UIDevice.current.orientation.isLandscape {
      renderAnimatedCombined(landscapePadding: scale)
    } else {
      renderAnimatedCombined(landscapePadding: 1.0)
    }
    
    
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
  
  
  func renderAnimatedCombined(landscapePadding: Double) {
    self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    let animationHandler = AnimationRenderer()
    let helper = HelperFunctions()
    let axis = AxisRenderer(frame: self.frame)
    let legend = LegendRenderer(frame: self.frame)
    
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
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
    
    
    
    
    for (i, value) in barConvertedData.enumerated() {
      animationHandler.drawAnimatedBar(array: value, maxValue: maxValue, minValue: 0, arrayCount: Double(barConvertedData.count), dataSetCount: i, offSet: offSet, mainLayer: layer, source: barChartDataSet.array[i])
    }
    
    for (i, value) in lineConvertedData.enumerated() {
      animationHandler.drawAnimatedLineGraph(array: value, maxValue: maxValue, minValue: 0, offSet: offSet, height: frameHeight(), width: frameWidth(), mainLayer: layer, source: lineChartDataSet.array[i])
      
    }
    
  }
  
  /// Renders a line graph
  func lineGraph(context: CGContext, array: [[Double]], max: Double, data: LineChartDataSet, forCombined: Bool, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let renderer = LineChartRenderer(frame: self.frame)

    for (i, value) in array.enumerated() {

      if enableLineBezier == true {
        //renderer.drawBezierCurve(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue,source: data.array[i], forCombined: true, offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
        //renderer.drawCircles(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
      } else {
        //renderer.drawLineForCombine(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue ,source: data.array[i],  offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
        renderer.drawCircles(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue, source: data.array[i], offSet: offSet, xGridlineCount: xAxis.setGridlineCount, yGridlineCount: yAxis.setGridlineCount)
      }
    }
  }

  func barGraph(context: CGContext, array: [[Double]], data: BarChartDataSet, max: Double, landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let renderer = BarChartRenderer(frame: self.frame)
    
    for (i, value) in array.enumerated() {
      renderer.drawVerticalBarGraph(context: context, array: value, maxValue: max, minValue: yAxis.setYAxisMinimumValue ,data: data.array[i], overallCount: Double(i), arrayCount: Double(array.count), offSet: offSet)
      print(value)
    }
  }

  func renderCombinedChart(context: CGContext, landscapePadding: Double, currentOrientation: orientation) {
    let helper = HelperFunctions()
    let axis = AxisRenderer(frame: self.frame)
    let legend = LegendRenderer(frame: self.frame)

    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)

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
    
    let generalCalculationHandler = GeneralGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), arrayCount: Double(arrayCount), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    
    let barRenderer = BarChartRenderer(frame: self.frame)
    axisBase(context: context, offSet: offSet)
    context.saveGState()
    yAxisGridlines(context: context, calc: generalCalculationHandler, gridlineCount: yAxis.setGridlineCount)
    barRenderer.barxAxisGridlines(context: context, arrayCount: arrayCount, offSet: offSet)
    context.restoreGState()
    //barGraph(context: context, array: barConvertedData, data: barChartDataSet, max: maxValue, landscapePadding: landscapePadding)
    lineGraph(context: context, array: lineConvertedData, max: maxValue, data: lineChartDataSet, forCombined: true, landscapePadding: landscapePadding)

    if yAxis.yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, minValue: yAxis.setYAxisMinimumValue, axisInverse: yAxis.enableYAxisInverse, offSet: offSet, gridlineCount: yAxis.setGridlineCount)
    }

    if xAxis.xAxisVisibility == true {
      axis.barGraphxAxis(context: context, arrayCount: arrayCount, offSet: offSet)
    }

    if legendVisibility == true {
      legend.renderCombinedChartLegend(context: context, data: data, position: legendPosition, customX: customXlegend, customY: customYlegend)
    }

  }

  
}
