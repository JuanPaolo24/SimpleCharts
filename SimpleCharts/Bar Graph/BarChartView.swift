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
    let maxValue = helper.processMultipleArrays(array: convertedData)
    
    
    xAxisBase(context: context)
    yAxisBase(context: context)
    renderVerticalBarGraph(context: context, array: data.array[0].array)
    yAxis(context: context, maxValue: maxValue)
    legend.renderBarChartLegend(context: context, arrays: data.array)
    
  }
  
  
  /// Renders a vertical bar graph
  func renderVerticalBarGraph(context: CGContext, array: [Double]) {
    var maxValue = 0.0
    let yAxisPadding = (frameHeight() - StaticVariables.distanceFromBottom)
    
    if let max = array.max() {
      maxValue = max + 41
    }
    
    for (i, value) in array.enumerated() {
      
      let arrayAccess = data.array[0]
      
      
      let xValue = (frameWidth() - 93) / Double(array.count)
      let yValuePosition = (yAxisPadding / maxValue) * value
      let yValue = yAxisPadding - yValuePosition
      
      let bar = CGRect(x: 36 + (xValue * Double(i)), y: yValue, width: xValue - 5, height: (frameHeight() - StaticVariables.sidePadding) - yValue)
      
      context.setFillColor(arrayAccess.setBarGraphFillColour)
      context.setStrokeColor(arrayAccess.setBarGraphStrokeColour)
      context.setLineWidth(arrayAccess.setBarGraphLineWidth)
      
      context.addRect(bar)
      context.drawPath(using: .fillStroke)
    }
    
  }

  
}
