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
  public var data = CombinedChartDataSet(lineData: LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")]), barData: BarChartDataSet(dataset: [BarChartData(dataset: [0], datasetName: "Test2")]))
  
  
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
    let helper = HelperFunctions()
    let axis = AxisRenderer(frame: self.frame)
    let legend = LegendRenderer(frame: self.frame)
  
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
    
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    barGraph(context: context, array: barConvertedData, initialValue: padding, graphType: "Vertical", data: barChartDataSet, max: maxValue)
    lineGraph(context: context, array: lineConvertedData, initialValue: padding, max: maxValue, data: lineChartDataSet, forCombined: true)
    yAxisGridlines(context: context, padding: padding)
    barxAxisGridlines(context: context, arrayCount: arrayCount, initialValue: padding)
    
    if yAxisVisibility == true {
      axis.yAxis(context: context, maxValue: maxValue, padding: padding - 10)
    }
    
    if xAxisVisibility == true {
      axis.barGraphxAxis(context: context, arrayCount: arrayCount, initialValue: padding, label: [])
    }
    
    if legendVisibility == true {
      legend.renderCombinedChartLegend(context: context, data: data)
    }
    
  }
  
  
}
