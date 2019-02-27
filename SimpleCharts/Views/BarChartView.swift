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
      renderVerticalBarGraph(context: context, padding: 70)
    } else {
      renderVerticalBarGraph(context: context, padding: 31)
    }
    
  }
  
  
  func renderVerticalBarGraph(context: CGContext, padding: Double) {
    let helper = RendererHelper()
    let legend = LegendRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    
    let axis = AxisRenderer(frame: self.frame)
    
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    barGraph(context: context, array: convertedData,initialValue: padding, graphType: "Vertical", data: data, max: maxValue)
    yAxisGridlines(context: context, padding: padding)
    axis.yAxis(context: context, maxValue: maxValue, padding: padding - 10)
    axis.barGraphxAxis(context: context, arrayCount: arrayCount, initialValue: padding)
    
    legend.renderBarChartLegend(context: context, arrays: data.array)
  }
  
}
