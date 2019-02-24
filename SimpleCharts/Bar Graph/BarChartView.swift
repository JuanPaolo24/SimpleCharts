//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 08/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartView: ChartRenderer {
  
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
      print("Landscape")
      renderLandscapeHorizontalBarGraph(context: context)
    } else {
      print("Portrait")
      renderHorizontalBarGraph(context: context)
    }

    
    

//    legend.renderBarChartLegend(context: context, arrays: data.array)
//    axis.horizontalBarGraphYAxis(context: context, arrayCount: arrayCount)
//    axis.horizontalBarGraphXAxis(context: context, maxValue: maxValue)
//    horizontalBarGraphYGridlines(context: context, arrayCount: arrayCount)
//    horizontalBarGraphXGridlines(context: context)
  }
  
  
  func renderBarVerticalGraph(context: CGContext) {
    
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    xAxisBase(context: context, padding: 30)
    yAxisBase(context: context, padding: 30)
    barGraph(context: context, array: convertedData, initialValue: 30)
    yAxisGridlines(context: context, padding: 30)
    axis.yAxis(context: context, maxValue: maxValue, padding: 20)
    axis.xAxis(context: context, arrayCount: arrayCount, initialValue: 30)
    
    
  }
  

  func renderLandscapeVerticalBarGraph(context: CGContext) {
    
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    xAxisBase(context: context, padding: 70)
    yAxisBase(context: context, padding: 70)
    barGraph(context: context, array: convertedData, initialValue: 70)
    yAxisGridlines(context: context, padding: 70)
    axis.yAxis(context: context, maxValue: maxValue, padding: 60)
    axis.xAxis(context: context, arrayCount: arrayCount, initialValue: 70)
    
    
  }
  
  
  
  func renderHorizontalBarGraph(context: CGContext) {
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    xAxisBase(context: context, padding: 30)
    yAxisBase(context: context, padding: 30)
    barGraph(context: context, array: convertedData, initialValue: 30)
    horizontalBarGraphXGridlines(context: context, initialValue: 30)
    horizontalBarGraphYGridlines(context: context, arrayCount: arrayCount, padding: 30)
    axis.horizontalBarGraphYAxis(context: context, arrayCount: arrayCount, padding: 20)
    axis.horizontalBarGraphXAxis(context: context, maxValue: maxValue, initialValue: 30)
  }
  
  func renderLandscapeHorizontalBarGraph(context: CGContext) {
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    xAxisBase(context: context, padding: 70)
    yAxisBase(context: context, padding: 70)
    barGraph(context: context, array: convertedData, initialValue: 70)
    horizontalBarGraphXGridlines(context: context, initialValue: 70)
    horizontalBarGraphYGridlines(context: context, arrayCount: arrayCount, padding: 70)
    axis.horizontalBarGraphYAxis(context: context, arrayCount: arrayCount, padding: 60)
    axis.horizontalBarGraphXAxis(context: context, maxValue: maxValue, initialValue: 70)
  }
  
  
  func barGraph(context: CGContext, array: [[Double]], initialValue: Double) {
    for (i, value) in array.enumerated() {
      //drawVerticalBarGraph(context: context, array: value, data: data.array[i], initialValue: initialValue)
      drawHorizontalBarGraph(context: context, array: value, data: data.array[i], initialValue: initialValue)
    }
    
    
  }

  
}
