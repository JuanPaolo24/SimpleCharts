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
  private var leftConfigxAxis = 10.0
  private var rightConfigxAxis = 60.0
  
  private var pieLegendMaximumDistance = CGFloat(100)
  private var bottomConfigyAxis = 80.0
  private var topConfigyAxis = 80.0
  
  private var pieLegendPadding = 0.0
  
  // Change the configuration of the legend based on the device orientation
  func legendPadding(currentOrientation: orientation) {
    if currentOrientation == .landscape {
      legendMaximumDistance = CGFloat(70)
      leftConfigxAxis = 70
      rightConfigxAxis = 120
      
      pieLegendMaximumDistance = CGFloat(350)
      bottomConfigyAxis = 20.0
      topConfigyAxis = 10.0
      pieLegendPadding = 50.0
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
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: legendText, textFrame: textFrame)
    legendMaximumDistance = textFrame.maxX + 5
    
    
  }
  
  /// Base function for drawing legends
  func drawPieLegend(context: CGContext, x: Double, y: Double, legendText: String, colour: CGColor) {
    let rectangleLegend = CGRect(x: x , y: y, width: 10, height: 10)
    context.setFillColor(colour)
    context.setLineWidth(1.0)
    context.addRect(rectangleLegend)
    context.drawPath(using: .fill)
    
    let textCount = Double(6 * legendText.count)
    let textFrame = CGRect(x: Double(rectangleLegend.maxX) + 5 , y: y, width: textCount, height: 10)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: legendText, textFrame: textFrame)
    pieLegendMaximumDistance = textFrame.maxX
    
    
  }
  

  
  func renderLineChartLegend(context: CGContext, arrays: [LineChartData], position: legendPlacing, customX: Double, customY: Double) {
    for i in 1...arrays.count {
      switch position {
      case.bottom:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineGraphColour)
      case.top:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: 20, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineGraphColour)
      case.right:
        drawLegend(context: context, x: Double(frame.size.width) - rightConfigxAxis, y: 20.0 * Double(i), legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineGraphColour)
      case.left:
        drawLegend(context: context, x: leftConfigxAxis, y: 20.0 * Double(i), legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineGraphColour)
      case.custom:
        drawLegend(context: context, x: customX, y: customY, legendText: arrays[i - 1].name, colour: arrays[i - 1].setLineGraphColour)
      }
    }
    
  }
  
  func renderBarChartLegend(context: CGContext, arrays: [BarChartData], position: legendPlacing, customX: Double, customY: Double) {
    for i in 1...arrays.count {
      switch position {
      case.bottom:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
      case.top:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: 20, legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
      case.right:
        drawLegend(context: context, x: Double(frame.size.width) - rightConfigxAxis, y: 20.0 * Double(i), legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
      case.left:
        drawLegend(context: context, x: leftConfigxAxis, y: 20.0 * Double(i), legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
      case.custom:
        drawLegend(context: context, x: customX, y: customY, legendText: arrays[i - 1].name, colour: arrays[i - 1].setBarGraphFillColour)
      }
    }
  }
  
  
  func renderPieChartLegend(context: CGContext, arrays: [PieChartData], position: pielegendPlacing, customX: Double, customY: Double) {
    for i in 1...arrays.count {
      switch position {
      case.bottom:
        drawPieLegend(context: context, x: Double(pieLegendMaximumDistance), y: Double(frame.size.height) - bottomConfigyAxis, legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.bottomleft:
        drawLegend(context: context, x: leftConfigxAxis + 35, y: Double(frame.size.height) - (50 + (Double(arrays.count - i) * 15)), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.bottomright:
        drawLegend(context: context, x: Double(frame.size.width) - rightConfigxAxis, y: Double(frame.size.height) - (50 + (Double(arrays.count - i) * 15)), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.top:
        drawPieLegend(context: context, x: Double(pieLegendMaximumDistance), y: topConfigyAxis, legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.topleft:
        drawLegend(context: context, x: leftConfigxAxis + 35, y: (30 + (Double(i) * 15)), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.topright:
        drawLegend(context: context, x: Double(frame.size.width) - rightConfigxAxis, y: (30 + (Double(i) * 15)), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.right:
        drawLegend(context: context, x: Double(frame.size.width) - (50 + pieLegendPadding), y: Double((frame.size.height/2) - 50) + (Double(i) * 15), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.left:
        drawLegend(context: context, x: 30 + pieLegendPadding, y: Double((frame.size.height/2) - 50) + (Double(i) * 15), legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      case.custom:
        drawLegend(context: context, x: customX, y: customY, legendText: arrays[i - 1].name, colour: arrays[i - 1].color.cgColor)
      }
      
      
      
    }
  }
  
  func renderCombinedChartLegend(context: CGContext, data: CombinedChartDataSet, position: legendPlacing, customX: Double, customY: Double) {
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
      legendColour.append(lineChartDataSet.array[i].setLineGraphColour)
      legendColour.append(barChartDataSet.array[i].setBarGraphFillColour)
    }
    
    for i in 0...dataCount {
      switch position {
      case.bottom:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: legendName[i], colour: legendColour[i])
      case.top:
        drawLegend(context: context, x: Double(legendMaximumDistance), y: 20, legendText: legendName[i], colour: legendColour[i])
      case.right:
        drawLegend(context: context, x: Double(frame.size.width) - rightConfigxAxis, y: 20.0 * Double(i + 1), legendText: legendName[i], colour: legendColour[i])
      case.left:
        drawLegend(context: context, x: leftConfigxAxis, y: 20.0 * Double(i + 1), legendText: legendName[i], colour: legendColour[i])
      case.custom:
        drawLegend(context: context, x: customX, y: customY, legendText: legendName[i], colour: legendColour[i])
      }
    }
    
  }
  
  
}
