//
//  LegendRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 20/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


enum legendPlacing {
  case left, right, bottom, top
}

enum orientation {
  case landscape, portrait
}


open class LegendRenderer: UIView {

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    /// Variable used by the legend to determine the distance between each one to prevent the text overlapping
  private var legendMaximumDistance = CGFloat(45)
  private var leftConfigxAxis = 10.0
  private var rightConfigxAxis = 60.0
  
  // Change the configuration of the legend based on the device orientation
  func legendPadding(currentOrientation: orientation) {
    if currentOrientation == .landscape {
      legendMaximumDistance = CGFloat(70)
      leftConfigxAxis = 70
      rightConfigxAxis = 120
    }
    
  }
  
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
  
  
  func drawPieLegend(context: CGContext, y: Double, legendText: String, colour: CGColor, offset: Double) {
    let x = Double(frame.size.width) - offset
    
    let rectangleLegend = CGRect(x: x, y: y, width: 10, height: 10)
    context.setFillColor(colour)
    context.setLineWidth(1.0)
    context.addRect(rectangleLegend)
    context.drawPath(using: .fill)
    
    let textCount = Double(6 * legendText.count)
    let textFrame = CGRect(x: Double(rectangleLegend.maxX) + 5, y: y, width: textCount, height: 10)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: legendText, textFrame: textFrame)
    
  }
  
  
  func renderLineChartLegend(context: CGContext, arrays: [LineChartData], position: legendPlacing) {
    for i in 1...arrays.count {
      switch position {
      case.bottom:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineColour)
      case.top:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: 20, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineColour)
      case.right:
        drawLegend(context: context, x: Double(frame.size.width) - rightConfigxAxis, y: 20.0 * Double(i), legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineColour)
      case.left:
        drawLegend(context: context, x: leftConfigxAxis, y: 20.0 * Double(i), legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineColour)
      }
    }
    
  }
  
  func renderBarChartLegend(context: CGContext, arrays: [BarChartData]) {
    for i in 1...arrays.count {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
    }
  }
  
  
  func renderPieChartLegend(context: CGContext, arrays: [PieChartData], padding: Double) {
    for i in 1...arrays.count {
      drawPieLegend(context: context, y: 30 + (Double(i) * 15), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor, offset: padding)
      
    }
  }
  
  func renderCombinedChartLegend(context: CGContext, data: CombinedChartDataSet) {
    let helper = HelperFunctions()
    let lineChartDataSet = data.lineData
    let barChartDataSet = data.barData
    
    let lineConvertedData = helper.convert(chartData: lineChartDataSet.array)
    let barConvertedData = helper.convert(chartData: barChartDataSet.array)
    let dataCount = (lineConvertedData.count + barConvertedData.count) - 1
    var legendName: [String] = []
    var legendColour: [CGColor] = []
    
    for i in 0...dataCount / 2 {
      legendName.append(lineChartDataSet.array[i].name)
      legendName.append(barChartDataSet.array[i].name)
      legendColour.append(lineChartDataSet.array[i].setLineColour)
      legendColour.append(barChartDataSet.array[i].setBarGraphFillColour)
    }
    
    for i in 0...dataCount {
      drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: legendName[i], colour: legendColour[i])
    }
    
  }
  
  
}
