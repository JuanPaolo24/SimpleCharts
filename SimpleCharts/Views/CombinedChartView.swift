//
//  CombinedChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class CombinedChartView: ChartRenderer {
  
  //Axis
  /// X axis labels visibility (Default = True)
  open var xAxisVisibility = true
  
  /// Returns true if X Axis label is visible
  open var isxAxisLabelVisible: Bool { get {return xAxisVisibility} }
  
  /// Y axis labels visibility (Default = True)
  open var yAxisVisibility = true
  
  /// Returns true if Y Axis label is visible
  open var isyAxisLabelVisible: Bool { get {return yAxisVisibility} }
  
  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Add the data source
  public var data = CombinedChartDataSet(dataset: [CombinedChartData(lineData: LineChartData(dataset: [0], datasetName: "Test"), barData: BarChartData(dataset: [0], datasetName: "Test"))])
  
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
      renderCombinedChart(context: context, padding: 70)
    } else {
      renderCombinedChart(context: context, padding: 30)
    }
    
    
  }
  
  
  func renderCombinedChart(context: CGContext, padding: Double) {
    
    for i in 0...data.array.count - 1 {
      
      let helper = HelperFunctions()
      let legend = LegendRenderer(frame: self.frame)
      let barConvertedData = helper.convert(chartData: data.array[i].barData)
      let lineConvertedData = helper.convert(chartData: data.array[i].lineData)
      
      
      let axis = AxisRenderer(frame: self.frame)
      
      let lineMax = helper.returnMaxValueFrom(array: lineConvertedData)
      let barMax = helper.returnMaxValueFrom(array: barConvertedData)
      
      let maxValue = max(lineMax, barMax)
      let barArrayCount = barConvertedData.count
      let lineArrayCount = lineConvertedData.count
      
      let arrayCount = max(barArrayCount, lineArrayCount)
      
      
      xAxisBase(context: context, padding: padding)
      yAxisBase(context: context, padding: padding)
      drawVerticalBarGraph(context: context, array: barConvertedData, maxValue: maxValue, data: data.array[i].barData, initialValue: padding, overallCount: Double(i), arrayCount: 1)
      drawLineGraph(context: context, array: lineConvertedData, maxValue: maxValue, source: data.array[i].lineData, initialValue: padding)
      yAxisGridlines(context: context, padding: padding)
      
      if yAxisVisibility == true {
        axis.yAxis(context: context, maxValue: maxValue, padding: padding - 10)
      }
      
      if xAxisVisibility == true {
        axis.barGraphxAxis(context: context, arrayCount: arrayCount, initialValue: padding)
      }
      
      if legendVisibility == true {
        legend.renderCombinedChartLegend(context: context, arrays: data.array)
      }
      
    }
    
    
  }
  
  
}
