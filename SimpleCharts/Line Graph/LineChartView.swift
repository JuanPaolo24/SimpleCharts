//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: ChartRenderer {
  
  public var data = LineChartData(dataset: [[0]])
  
  override public init(frame: CGRect) {
    self.data = LineChartData(dataset: [[0]])
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
    
    
    let maxValue = helper.processMultipleArrays(array: data.array)
    let arrayCount = helper.findArrayCount(array: data.array)
    
    xAxisBase(context: context)
    yAxisBase(context: context)
    lineGraph(context: context, array: data.array)
    yAxis(context: context, maxValue: maxValue)
    xAxis(context: context, arrayCount: arrayCount)
    renderLegend(context: context, chartType: "Line")

    
    
  }
  
}



