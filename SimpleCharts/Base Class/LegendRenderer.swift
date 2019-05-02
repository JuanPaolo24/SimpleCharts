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
  func drawLegend(in context: CGContext, as legendShape: legendShape, x: Double, y: Double, legendText: String, colour: CGColor) {
    let rectangleLegend = CGRect(x: x , y: y, width: 10, height: 10)
    let circlePoint = CGPoint(x: rectangleLegend.midX, y: rectangleLegend.midY)
    context.setFillColor(colour)
    context.setLineWidth(1.0)
    if legendShape == .rectangle {
      context.addRect(rectangleLegend)
      context.drawPath(using: .fill)
    } else {
      context.addArc(center: circlePoint, radius: 5.0, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
      context.fillPath()
    }
    
    let textCount = Double(6 * legendText.count)
    let textFrame = CGRect(x: Double(rectangleLegend.maxX) + 5 , y: y, width: textCount, height: 10)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: legendText, textFrame: textFrame)
    legendMaximumDistance = textFrame.maxX + 5
    
    
  }
  
  /// Base function for drawing legends
  func drawPieLegend(in context: CGContext, as legendShape: legendShape, x: Double, y: Double, legendText: String, colour: CGColor) {
    let rectangleLegend = CGRect(x: x , y: y, width: 10, height: 10)
    let circlePoint = CGPoint(x: rectangleLegend.midX, y: rectangleLegend.midY)
    context.setFillColor(colour)
    context.setLineWidth(1.0)
    if legendShape == .rectangle {
      context.addRect(rectangleLegend)
      context.drawPath(using: .fill)
    } else {
      context.addArc(center: circlePoint, radius: 5.0, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
      context.fillPath()
    }
    let textCount = Double(6 * legendText.count)
    let textFrame = CGRect(x: Double(rectangleLegend.maxX) + 5 , y: y, width: textCount, height: 10)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: legendText, textFrame: textFrame)
    pieLegendMaximumDistance = textFrame.maxX
    
    
  }
  

  //Add a line chart legend
  func addLegend(to context: CGContext, using arrays: [LineChartData], and position: legendPlacing, _ customX: Double, _ customY: Double) {
    for increment in 1...arrays.count {
      let legendColour = arrays[increment - 1].setLineGraphColour
      let dataSetName = arrays[increment - 1].name
      let shape = arrays[increment - 1].setLegendShape
      let frameHeight = Double(frame.size.height)
      let frameWidth = Double(frame.size.width)
      let distanceBetweenLegend = Double(legendMaximumDistance)
      switch position {
      case.bottom:
        drawLegend(in: context, as: shape, x: distanceBetweenLegend, y: frameHeight - 30, legendText: dataSetName, colour: legendColour)
      case.top:
        drawLegend(in: context, as: shape, x: distanceBetweenLegend, y: 20, legendText: dataSetName, colour: legendColour)
      case.right:
        drawLegend(in: context, as: shape, x: frameWidth - rightConfigxAxis, y: 20.0 * Double(increment), legendText: dataSetName, colour: legendColour)
      case.left:
        drawLegend(in: context, as: shape, x: leftConfigxAxis, y: 20.0 * Double(increment), legendText: dataSetName, colour: legendColour)
      case.custom:
        drawLegend(in: context, as: shape, x: customX, y: customY, legendText: dataSetName, colour: legendColour)
      }
    }
  }
  
  //Add a bar chart legend
  func addLegend(to context: CGContext, using arrays: [BarChartData], and position: legendPlacing, _ customX: Double, _ customY: Double) {
    for increment in 1...arrays.count {
      let legendColour = arrays[increment - 1].setBarGraphFillColour
      let dataSetName = arrays[increment - 1].name
      let shape = arrays[increment - 1].setLegendShape
      let frameHeight = Double(frame.size.height)
      let frameWidth = Double(frame.size.width)
      let distanceBetweenLegend = Double(legendMaximumDistance)
      switch position {
      case.bottom:
        drawLegend(in: context, as: shape, x: distanceBetweenLegend, y: frameHeight - 30, legendText: dataSetName, colour: legendColour)
      case.top:
        drawLegend(in: context, as: shape, x: distanceBetweenLegend, y: 20, legendText: dataSetName, colour: legendColour)
      case.right:
        drawLegend(in: context, as: shape, x: frameWidth - rightConfigxAxis, y: 20.0 * Double(increment), legendText: dataSetName, colour: legendColour)
      case.left:
        drawLegend(in: context, as: shape, x: leftConfigxAxis, y: 20.0 * Double(increment), legendText: dataSetName, colour: legendColour)
      case.custom:
        drawLegend(in: context, as: shape, x: customX, y: customY, legendText: dataSetName, colour: legendColour)
      }
    }
  }
  
  //Add a pie chart legend
  func addLegend(to context: CGContext, using arrays: [PieChartData], and position: pielegendPlacing, _ customX: Double, _ customY: Double) {
    for increment in 1...arrays.count {
      let legendColour = arrays[increment - 1].color.cgColor
      let dataSetName = arrays[increment - 1].name
      let shape = arrays[increment - 1].setLegendShape
      let frameHeight = Double(frame.size.height)
      let frameWidth = Double(frame.size.width)
      let distanceBetweenLegend = Double(pieLegendMaximumDistance)
      switch position {
      case.bottom:
        drawPieLegend(in: context, as: shape,x: distanceBetweenLegend, y: frameHeight - bottomConfigyAxis, legendText: dataSetName, colour: legendColour)
      case.bottomleft:
        drawLegend(in: context, as: shape, x: leftConfigxAxis + 35, y: frameHeight - (50 + (Double(arrays.count - increment) * 15)), legendText: dataSetName, colour: legendColour)
      case.bottomright:
        drawLegend(in: context, as: shape, x: frameWidth - rightConfigxAxis, y: frameHeight - (50 + (Double(arrays.count - increment) * 15)), legendText: dataSetName, colour: legendColour)
      case.top:
        drawPieLegend(in: context, as: shape, x: distanceBetweenLegend, y: topConfigyAxis, legendText: dataSetName, colour: legendColour)
      case.topleft:
        drawLegend(in: context, as: shape, x: leftConfigxAxis + 35, y: (30 + (Double(increment) * 15)), legendText: dataSetName, colour: legendColour)
      case.topright:
        drawLegend(in: context, as: shape, x: frameWidth - rightConfigxAxis, y: (30 + (Double(increment) * 15)), legendText: dataSetName, colour: legendColour)
      case.right:
        drawLegend(in: context, as: shape, x: frameWidth - (50 + pieLegendPadding), y: ((frameHeight/2) - 50) + (Double(increment) * 15), legendText: dataSetName, colour: legendColour)
      case.left:
        drawLegend(in: context, as: shape, x: 30 + pieLegendPadding, y: ((frameHeight/2) - 50) + (Double(increment) * 15), legendText: dataSetName, colour: legendColour)
      case.custom:
        drawLegend(in: context, as: shape, x: customX, y: customY, legendText: dataSetName, colour: legendColour)
      }
    }
  }
  
  
  func addLegend(to context: CGContext, as shape: legendShape, using data: CombinedChartDataSet, and position: legendPlacing, _ customX: Double, _ customY: Double) {
    let helper = HelperFunctions()
    let lineChartDataSet = data.lineData
    let barChartDataSet = data.barData
    
    let lineConvertedData = helper.convertToDouble(from: lineChartDataSet.array)
    let barConvertedData = helper.convertToDouble(from: barChartDataSet.array)
    let dataCount = (lineConvertedData.count + barConvertedData.count)
    var legendName: [String] = []
    var legendColour: [CGColor] = []
    
    if lineConvertedData.count < 1 {
      legendName.append("No Line Data")
      legendColour.append(UIColor.black.cgColor)
    } else {
      for increment in 0...lineConvertedData.count - 1 {
        legendName.append(lineChartDataSet.array[increment].name)
        legendColour.append(lineChartDataSet.array[increment].setLineGraphColour)
      }
    }
    
    if barConvertedData.count < 1 {
      legendName.append("No Bar Data")
      legendColour.append(UIColor.black.cgColor)
    } else {
      for increment in 0...barConvertedData.count - 1 {
        legendName.append(barChartDataSet.array[increment].name)
        legendColour.append(barChartDataSet.array[increment].setBarGraphFillColour)
      }
    }
    
    
    if dataCount > 1 {
      for increment in 0...dataCount - 1 {
        switch position {
        case.bottom:
          drawLegend(in: context, as: shape, x: Double(legendMaximumDistance), y: Double(frame.size.height) - 30, legendText: legendName[increment], colour: legendColour[increment])
        case.top:
          drawLegend(in: context, as: shape, x: Double(legendMaximumDistance), y: 20, legendText: legendName[increment], colour: legendColour[increment])
        case.right:
          drawLegend(in: context, as: shape, x: Double(frame.size.width) - rightConfigxAxis, y: 20.0 * Double(increment + 1), legendText: legendName[increment], colour: legendColour[increment])
        case.left:
          drawLegend(in: context, as: shape, x: leftConfigxAxis, y: 20.0 * Double(increment + 1), legendText: legendName[increment], colour: legendColour[increment])
        case.custom:
          drawLegend(in: context, as: shape, x: customX, y: customY, legendText: legendName[increment], colour: legendColour[increment])
        }
      }
    }
    
    
  }
  
  
}
