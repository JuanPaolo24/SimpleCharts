//
//  LegendRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 20/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LegendRenderer: UIView {

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
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: legendText, textFrame: textFrame)
    legendMaximumDistance = textFrame.maxX + 5
    
  }
  
  func renderLineChartLegend(context: CGContext, arrays: [LineChartData]) {
    for i in 1...arrays.count {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineColour)
    }
    
  }
  
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
  
  func renderCombinedChartLegend(context: CGContext, arrays: [CombinedChartData]) {
    var legendName:[String] = [arrays[0].barData.name, arrays[0].lineData.name]
    var legendColour:[CGColor] = [arrays[0].barData.setBarGraphFillColour, arrays[0].lineData.setLineColour]
    
    for i in 0...arrays.count {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: legendName[i], colour: legendColour[i])
    }
  }
  
  
}
