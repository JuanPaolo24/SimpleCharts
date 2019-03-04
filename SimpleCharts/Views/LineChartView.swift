//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: ChartRenderer {
  
  
  public var data = LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //Axis
  /// X axis labels visibility (Default = True)
  open var xAxisVisibility = true
  
  /// Y axis labels visibility (Default = True)
  open var yAxisVisibility = true
  
  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  
  /// Line type
  open var enableBezierCurve = true
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    if enableBezierCurve {
      if UIDevice.current.orientation.isLandscape {
        renderBezierGraph(context: context, padding: 70)
      } else {
        renderBezierGraph(context: context, padding: 31)
      }
    } else {
      if UIDevice.current.orientation.isLandscape {
        renderLineGraph(context: context, padding: 70)
      } else {
        renderLineGraph(context: context, padding: 31)
      }
      
    }
    
    
  }
  
  func renderLineGraph(context: CGContext, padding: Double) {
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    lineGraph(context: context, array: convertedData, initialValue: padding)
    yAxisGridlines(context: context, padding: padding)
    xAxisGridlines(context: context, arrayCount: arrayCount, initialValue: padding)
    
    if yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, padding: padding - 10)
    }
  
    if xAxisVisibility == true {
      axis.xAxis(context: context, arrayCount: arrayCount, initialValue: padding)
    }
    
    if legendVisibility == true {
      legend.renderLineChartLegend(context: context, arrays: data.array)
    }
    
  }
  
  
  
  func renderBezierGraph(context: CGContext, padding: Double) {
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
   
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    lineBezierGraph(context: context, array: convertedData, initialValue: padding)
    yAxisGridlines(context: context, padding: padding)
    xAxisGridlines(context: context, arrayCount: arrayCount, initialValue: padding)
    axis.yAxis(context: context, maxValue: maxValue, padding: padding - 10)
    axis.xAxis(context: context, arrayCount: arrayCount, initialValue: padding)
    legend.renderLineChartLegend(context: context, arrays: data.array)
    
  }
  
  
  /// Renders a line graph
  func lineGraph(context: CGContext, array: [[Double]], initialValue: Double) {
    let helper = RendererHelper()
    let max = helper.processMultipleArrays(array: array)
    
    for (i, value) in array.enumerated() {
      drawLineGraph(context: context, array: value, maxValue: max, source: data.array[i], initialValue: initialValue)
    }
  }
  
  
  /// Renders a line graph
  func lineBezierGraph(context: CGContext, array: [[Double]], initialValue: Double) {
    let helper = RendererHelper()
    let max = helper.processMultipleArrays(array: array)

    for (i, value) in array.enumerated() {
      drawBezierCurve(context: context, array: value, maxValue: max, source: data.array[i] ,initialValue: initialValue)
    }
  }
  
  
}



