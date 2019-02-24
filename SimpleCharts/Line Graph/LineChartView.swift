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
    self.data = LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")])
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
      print("Landscape")
      renderLandscapeGraph(context: context)
    } else {
      print("Portrait")
      renderGraph(context: context)
    }
    
  }
  
  
  func renderGraph(context: CGContext) {
    let helper = RendererHelper()
    
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    
    let convertedData = helper.convert(chartData: data.array)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    xAxisBase(context: context, padding: 30)
    yAxisBase(context: context, padding: 30)
    lineGraph(context: context, array: convertedData, initialValue: 31)
    yAxisGridlines(context: context, padding: 30)
    xAxisGridlines(context: context, arrayCount: arrayCount, initialValue: 31)
    axis.yAxis(context: context, maxValue: maxValue, padding: 20)
    axis.xAxis(context: context, arrayCount: arrayCount, initialValue: 31)
    legend.renderLineChartLegend(context: context, arrays: data.array)
  }
  
  func renderLandscapeGraph(context: CGContext) {
    let helper = RendererHelper()
    
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    
    let convertedData = helper.convert(chartData: data.array)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    yAxisBase(context: context, padding: 70)
    xAxisBase(context: context, padding: 70)
    lineGraph(context: context, array: convertedData, initialValue: 70)
    yAxisGridlines(context: context, padding: 70)
    xAxisGridlines(context: context, arrayCount: arrayCount, initialValue: 70)
    axis.xAxis(context: context, arrayCount: arrayCount, initialValue: 70)
    axis.yAxis(context: context, maxValue: maxValue, padding: 60)
    
  }
  
  
  /// Renders a line graph
  func lineGraph(context: CGContext, array: [[Double]], initialValue: Double) {
    let helper = RendererHelper()
    let max = helper.processMultipleArrays(array: array)

    for (i, value) in array.enumerated() {
      drawLineGraph(context: context, array: value, maxValue: max, source: data.array[i], initialValue: initialValue)
    }
  }
  
  
}



