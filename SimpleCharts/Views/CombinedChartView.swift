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
  
  /// Legend Shape (Default = Rectangle)
  open var legendShape: legendShape = .rectangle
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  /// Enables the axis label customisation, if it is false then the max value of the data set will be taken and multiplied by 20% (Default = false)
  open var enableAxisCustomisation = false
  
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
  
  /// The orientation of the graph
  open var barOrientation: barOrientation = .vertical
  
  /// Line type
  open var lineType: lineType = .normal
  
  /// Activate animation
  open var enableAnimation:Bool = false
  
  /// Enable highlighting (Default = true)
  open var enableHighlight: Bool = false
  
  /// Add the data source
  public var data = CombinedChartDataSet()
  
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override open func layoutSubviews() {
    let scale = 70.0/31.0
    
    
    if enableAnimation == true {
      setNeedsDisplay()
      if UIDevice.current.orientation.isLandscape {
        renderAnimatedCombined(landscapePadding: scale)
      } else {
        renderAnimatedCombined(landscapePadding: 1.0)
      }
    } else {
      setNeedsDisplay()
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
      renderGraphBase(as: .landscape, on: context, withConfiguration: scale)
      renderCombineChart(on: context, withConfiguration: scale)
    } else {
      renderGraphBase(as: .portrait, on: context, withConfiguration: 1.0)
      renderCombineChart(on: context, withConfiguration: 1.0)
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
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
    let lineChartDataSet = data.lineData
    let barChartDataSet = data.barData
    
    let lineConvertedData = helper.convertToDouble(from: lineChartDataSet.array)
    let barConvertedData = helper.convertToDouble(from: barChartDataSet.array)
    
    let lineMaxValue = helper.findMaxValueFrom(lineConvertedData)
    let barMaxValue = helper.findMaxValueFrom(barConvertedData)
    let actualMax = max(lineMaxValue, barMaxValue)
    
    let lineArrayCount = helper.findArrayCountFrom(array: lineConvertedData)
    let barArrayCount = helper.findArrayCountFrom(array: barConvertedData)
    let arrayCount = max(lineArrayCount, barArrayCount)
    
    var maxValue = 0.0
    var minValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
  
    for (increment, value) in barConvertedData.enumerated() {
      animationHandler.calculate = GraphCalculation(array: value, arrayCount: value.count, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      animationHandler.barCustomisationSource = barChartDataSet.array[increment]
      animationHandler.drawAnimatedBar(on: layer, using: value, with: Double(increment), and: Double(barConvertedData.count), for: barOrientation)
    }
    
    for (increment, value) in lineConvertedData.enumerated() {
      animationHandler.calculate = GraphCalculation(array: value, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      animationHandler.lineCustomisationSource = lineChartDataSet.array[increment]
      animationHandler.drawAnimatedCombineLine(on: layer, using: value)
    }
    
  }
  
  
  func renderCombineChart(on context: CGContext, withConfiguration landscapePadding: Double) {
    let helper = HelperFunctions()
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let lineRenderer = LineChartRenderer(frame: self.frame)
    let barRenderer = BarChartRenderer(frame: self.frame)
    
    let lineChartDataSet = data.lineData
    let barChartDataSet = data.barData
    
    let lineConvertedData = helper.convertToDouble(from: lineChartDataSet.array)
    let barConvertedData = helper.convertToDouble(from: barChartDataSet.array)
    
    let lineMaxValue = helper.findMaxValueFrom(lineConvertedData)
    let barMaxValue = helper.findMaxValueFrom(barConvertedData)
    let actualMax = max(lineMaxValue, barMaxValue)
    
    let lineArrayCount = helper.findArrayCountFrom(array: lineConvertedData)
    let barArrayCount = helper.findArrayCountFrom(array: barConvertedData)
    let arrayCount = max(lineArrayCount, barArrayCount)
    
    var maxValue = 0.0
    var minValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    for (increment, value) in barConvertedData.enumerated() {
      barRenderer.calculate = GraphCalculation(array: value, arrayCount: value.count, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      barRenderer.customisationSource = barChartDataSet.array[increment]
      if enableAnimation == false {
        barRenderer.addVerticalBarGraph(to: context, from: value, with: Double(increment), and: Double(barConvertedData.count))
      }
    }
    
    for (increment, value) in lineConvertedData.enumerated() {
      lineRenderer.calculate = GraphCalculation(array: value, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      lineRenderer.sourceData = lineChartDataSet.array[increment]
      if enableAnimation == false {
        lineRenderer.addCircles(to: context, from: value, for: .combineChart)
        if lineType == .bezier {
          lineRenderer.addBezierLine(to: context, from: value, for: .combineChart)
        } else {
          lineRenderer.addLine(to: context, from: value, for: .combineChart)
        }
      }
    }
  }

  
  

  func renderGraphBase(as currentOrientation: orientation, on context:CGContext, withConfiguration landscapePadding: Double) {
    let helper = HelperFunctions()
    let axis = AxisLabelRenderer(frame: self.frame)
    let legend = LegendRenderer(frame: self.frame)
    legend.legendPadding(currentOrientation: currentOrientation)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
    let lineChartDataSet = data.lineData
    let barChartDataSet = data.barData
    
    let lineConvertedData = helper.convertToDouble(from: lineChartDataSet.array)
    let barConvertedData = helper.convertToDouble(from: barChartDataSet.array)
    
    let lineMaxValue = helper.findMaxValueFrom(lineConvertedData)
    let barMaxValue = helper.findMaxValueFrom(barConvertedData)
    let actualMax = max(lineMaxValue, barMaxValue)
    
    let lineArrayCount = helper.findArrayCountFrom(array: lineConvertedData)
    let barArrayCount = helper.findArrayCountFrom(array: barConvertedData)
    let arrayCount = max(lineArrayCount, barArrayCount)
    
    var maxValue = 0.0
    var minValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    axis.calculate = GraphCalculation(array: [], arrayCount: arrayCount, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    
    axisBase(context: context, offSet: offSet)
    context.protectGState {
      drawYAxisGridline(on: context, using: yAxis.setGridlineCount)
      drawBarXAxisGridline(on: context, using: arrayCount)
    }
      axis.drawYAxisLabel(on: context, using: yAxis.setGridlineCount, withAxisInverse: yAxis.enableYAxisInverse, and: yAxis.rightYAxisVisibility, yAxis.leftYAxisVisibility)
      axis.drawbarXAxisLabel(on: context, withCustomisation: enableAxisCustomisation, using: arrayCount, and: xAxis.setXAxisLabel, with: xAxis.bottomXAxisVisibility, xAxis.topXAxisVisibility)
    if legendVisibility == true {
      legend.addLegend(to: context, as: legendShape, using: data, and: legendPosition, customXlegend, customYlegend)
    }
  }
  
}
