//
//  LegendRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 20/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LegendRenderer: UIView {
  
  let helper = RendererHelper()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    /// Variable used by the legend to determine the distance between each one to prevent the text overlapping
  private var legendMaximumDistance = CGFloat(45)
  
  
  /// Base function for drawing legends
  func drawLegend(context: CGContext, x: Double, y: Double, legendText: String, colour: CGColor) {
    let rectangleLegend = CGRect(x: x , y: y, width: 10, height: 10)
    context.setFillColor(colour)
    context.setLineWidth(1.0)
    context.addRect(rectangleLegend)
    context.drawPath(using: .fill)
    
    let textCount = Double(6 * legendText.count)
    let textFrame = CGRect(x: Double(rectangleLegend.maxX) + 5 , y: y, width: textCount, height: 10)
    
    helper.renderText(text: legendText, textFrame: textFrame)
    legendMaximumDistance = textFrame.maxX + 5
    
  }
  
  /// Takes the data from the array and creates legend depending on the amount of line there is on the graph
  func renderLineChartLegend(context: CGContext, arrays: [LineChartData]) {
    for i in 1...arrays.count {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLinePointColour)
    }
    
  }
  
  /// Takes the data from the array and creates legend depending on the amount of bar there is on the graph
  func renderBarChartLegend(context: CGContext, arrays: [BarChartData]) {
    for i in 1...arrays.count {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
    }
  }
  
  
  func renderPieChartLegend(context: CGContext, arrays: [PieChartData]) {
    for i in 1...arrays.count {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 80, legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
    }
  }
  
}
