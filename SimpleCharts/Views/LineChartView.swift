//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: ChartRenderer {
  
  
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
  
  /// Returns true if legend is visible
  open var isLegendVisible: Bool { get {return legendVisibility} }
  
  
  /// Line type
  open var enableBezierCurve = true
  
  
  public var data = LineChartDataSet(dataset: [LineChartData(dataset: [0], datasetName: "Test")])
  
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
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    
    
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    lineGraph(context: context, array: convertedData, initialValue: padding, max: maxValue, data: data, forCombined: false)
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
    let helper = HelperFunctions()
    let legend = LegendRenderer(frame: self.frame)
    let axis = AxisRenderer(frame: self.frame)
    let convertedData = helper.convert(chartData: data.array)
    let maxValue = helper.processMultipleArrays(array: convertedData)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
   
    xAxisBase(context: context, padding: padding)
    yAxisBase(context: context, padding: padding)
    lineBezierGraph(context: context, array: convertedData, initialValue: padding, data: data)
    yAxisGridlines(context: context, padding: padding)
    xAxisGridlines(context: context, arrayCount: arrayCount, initialValue: padding)
    axis.yAxis(context: context, maxValue: maxValue, padding: padding - 10)
    axis.xAxis(context: context, arrayCount: arrayCount, initialValue: padding)
    legend.renderLineChartLegend(context: context, arrays: data.array)
    
  }
  

}



