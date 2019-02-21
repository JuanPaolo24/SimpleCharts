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
    
    
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCount(array: convertedData)
    
    
    xAxisBase(context: context)
    yAxisBase(context: context)
    barGraph(context: context, array: convertedData)
//    yAxisGridlines(context: context)
//    axis.yAxis(context: context, maxValue: maxValue)
//    axis.xAxis(context: context, arrayCount: arrayCount)
//    legend.renderBarChartLegend(context: context, arrays: data.array)
    axis.horizontalBarGraphYAxis(context: context, arrayCount: arrayCount)
    axis.horizontalBarGraphXAxis(context: context, maxValue: maxValue)
    horizontalBarGraphYGridlines(context: context, arrayCount: arrayCount)
    horizontalBarGraphXGridlines(context: context)
  }
  
  
  func barGraph(context: CGContext, array: [[Double]]) {
    for (i, value) in array.enumerated() {
      //drawVerticalBarGraph(context: context, array: value, data: data.array[i])
      drawHorizontalBarGraph(context: context, array: value, data: data.array[i])
    }
    
    
  }

  
}
