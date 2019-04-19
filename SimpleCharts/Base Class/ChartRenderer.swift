//
//  ChartRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics

open class ChartRenderer: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  

  //General
  /// Enable the Y gridline on the chart
  open var enableYGridline = true
  
  /// Returns true if Y gridline is visible
  open var isYGridlineVisible: Bool { get {return enableYGridline} }
  
  /// Enable the X gridline on the chart
  open var enableXGridline = true
  
  /// Returns true if X gridline is visible
  open var isXGridlineVisible: Bool { get {return enableXGridline} }
  
  /// Set the Y Axis base colour (Default = Black)
  open var setYAxisBaseColour = UIColor.black.cgColor
  
  /// Set the X Axis base colour (Default = Black)
  open var setXAxisBaseColour = UIColor.black.cgColor
  
  /// Set Gridline colour (Default = Black)
  open var setGridlineColour = UIColor.black.cgColor
  
  /// Set Gridline Line Width (Default = 0.5)
  open var setGridlineWidth = CGFloat(0.5)
  
  /// Set the Gridline stroke design (Default = True)
  open var enableGridLineDash = true
  
  /// Returns true if gridline dash is enabled
  open var isGridlineDashEnabled: Bool { get {return enableGridLineDash} }
  
  /// Returns the height of the current frame as a double
  func frameHeight() -> Double {
    let frameHeight = Double(frame.size.height)
    
    return frameHeight
  }
  
  /// Returns the width of the current frame as a double
  func frameWidth() -> Double {
    let frameWidth = Double(frame.size.width)
    
    return frameWidth
  }
  

  // Base function for drawing axis bases
  func drawAxisBase(context: CGContext, start: CGPoint, end: CGPoint, strokeColour: CGColor, width: CGFloat) {
    let axisBase = CGMutablePath()
    axisBase.move(to: start)
    axisBase.addLine(to: end)
    context.addPath(axisBase)
    context.setLineWidth(width)
    context.setStrokeColor(strokeColour)
    context.strokePath()
  }
  
  // Draws the graph outline onto the context.
  func axisBase(context: CGContext, offSet: offset) {
    let yAxisPadding = frameHeight() - offSet.bottom
    let xAxisPadding = frameWidth() - offSet.right
    
    let leftBaseStartPoint = CGPoint(x: offSet.left, y: offSet.top)
    let leftBaseEndPoint = CGPoint(x: offSet.left, y: yAxisPadding)
    
    let rightBaseStartPoint = CGPoint(x: xAxisPadding, y: offSet.top)
    let rightBaseEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding)
    
    let bottomBaseStartPoint = CGPoint(x: offSet.left, y: yAxisPadding)
    let bottomBaseEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding)
    
    let upperBaseStartPoint = CGPoint(x: offSet.left, y: offSet.top)
    let upperBaseEndPoint = CGPoint(x: xAxisPadding, y: offSet.top)
    
    drawAxisBase(context: context, start: leftBaseStartPoint, end: leftBaseEndPoint, strokeColour: setYAxisBaseColour, width: 1.0)
    drawAxisBase(context: context, start: rightBaseStartPoint, end: rightBaseEndPoint, strokeColour: setYAxisBaseColour, width: 1.0)
    drawAxisBase(context: context, start: bottomBaseStartPoint, end: bottomBaseEndPoint, strokeColour: setXAxisBaseColour, width: 1.0)
    drawAxisBase(context: context, start: upperBaseStartPoint, end: upperBaseEndPoint, strokeColour: setXAxisBaseColour, width: 1.0)
    
  }
  
  /// Base function for drawing gridlines using the start and end points
  func drawGridLines(context: CGContext, start: CGPoint, end: CGPoint) {
    
    let gridLine = CGMutablePath()
    gridLine.move(to: start)
    gridLine.addLine(to: end)
    context.addPath(gridLine)
    context.setStrokeColor(setGridlineColour)
    context.strokePath()
    context.setLineWidth(setGridlineWidth)
    
    if enableGridLineDash == true {
      context.setLineDash(phase: 0, lengths: [1])
    }
    
  }

  /// Renders the Y axis Gridlines
  func yAxisGridlines(context: CGContext, calc: GeneralGraphCalculation, gridlineCount: Double) {
    context.protectGState {
      for i in 0...Int(gridlineCount) {
        let yStartPoint = calc.yGridlinePoint(i: i, destination: position.start)
        let yEndPoint = calc.yGridlinePoint(i: i, destination: position.end)
        
        if enableYGridline == true {
          drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
        }
      }
    }
    
  }
  
  /// Renders the X axis Gridlines
  func xAxisGridlines(context: CGContext, calc: GeneralGraphCalculation, gridlineCount: Double) {
    context.protectGState {
      for i in 0...Int(gridlineCount) {
        let startPoint = calc.xGridlinePoint(distanceIncrement: i, destination: position.start)
        let endPoint = calc.xGridlinePoint(distanceIncrement: i, destination: position.end)
        if enableXGridline == true {
          drawGridLines(context: context, start: startPoint, end: endPoint)
        }
        
      }
    }
  }

  
}





