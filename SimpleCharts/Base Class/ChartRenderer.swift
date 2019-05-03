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
  
  var calculate = GraphCalculation()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //General
  /// Enable the Y gridline on the chart
  open var enableYGridVisibility: Bool = true
  
  /// Enable the X gridline on the chart
  open var enableXGridVisibility: Bool = true
  
  /// Set the Axis base color (Default = Black)
  open var setAxisBaseColor: UIColor = UIColor.black

  /// Set axis base width (Default = 1.0)
  open var setAxisBaseWidth: CGFloat = 1.0
  
  /// Set Gridline color (Default = Black)
  open var setGridlineColor: UIColor = UIColor.black
  
  /// Set Gridline Line Width (Default = 0.5)
  open var setGridlineWidth: CGFloat = 0.5
  
  /// Set the Gridline stroke design (Default = True)
  open var enableGridLineDash: Bool = true
  
  /// Only works when enable gridline dash is set to true (Default = 0.0)
  open var setGridlineDashPhase: CGFloat = 0.0
  
  /// Only works when enable gridline dash is set to true (Default = [1])
  open var setGridlineDashLengths: [CGFloat] = [1]
  
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
  func drawAxisBase(context: CGContext, start: CGPoint, end: CGPoint) {
    let axisBase = CGMutablePath()
    axisBase.move(to: start)
    axisBase.addLine(to: end)
    context.addPath(axisBase)
    context.setLineWidth(setAxisBaseWidth)
    context.setStrokeColor(setAxisBaseColor.cgColor)
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
    
    drawAxisBase(context: context, start: leftBaseStartPoint, end: leftBaseEndPoint)
    drawAxisBase(context: context, start: rightBaseStartPoint, end: rightBaseEndPoint)
    drawAxisBase(context: context, start: bottomBaseStartPoint, end: bottomBaseEndPoint)
    drawAxisBase(context: context, start: upperBaseStartPoint, end: upperBaseEndPoint)
    
  }
  
  /// Base function for drawing gridlines using the start and end points
  func drawGridLines(context: CGContext, start: CGPoint, end: CGPoint) {
    
    let gridLine = CGMutablePath()
    gridLine.move(to: start)
    gridLine.addLine(to: end)
    context.addPath(gridLine)
    context.setStrokeColor(setGridlineColor.cgColor)
    context.strokePath()
    context.setLineWidth(setGridlineWidth)
    
    if enableGridLineDash == true {
      context.setLineDash(phase: setGridlineDashPhase, lengths: setGridlineDashLengths)
    }
    
  }

  /// Renders the Y axis Gridlines
  func drawYAxisGridline(on context: CGContext, using gridlineCount: Double) {
    context.protectGState {
      for increment in 0...Int(gridlineCount) {
        let yStartPoint = calculate.yGridlinePoint(using: increment, for: .start)
        let yEndPoint = calculate.yGridlinePoint(using: increment, for: .end)
        
        if enableYGridVisibility == true {
          drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
        }
      }
    }
    
  }
  
  /// Renders the X axis Gridlines
  func drawXAxisGridline(on context: CGContext, using gridlineCount: Double) {
    context.protectGState {
      for increment in 0...Int(gridlineCount) {
        let startPoint = calculate.xGridlinePoint(using: increment, for: .start)
        let endPoint = calculate.xGridlinePoint(using: increment, for: .end)
        if enableXGridVisibility == true {
          drawGridLines(context: context, start: startPoint, end: endPoint)
        }
        
      }
    }
  }
  
  
  /// Renders a special X axis gridline for the bar chart
  func drawBarXAxisGridline(on context: CGContext, using arrayCount: Int) {
    for increment in 0...arrayCount - 1 {
      let startPoint = calculate.barXGridlinePoint(using: increment, for: .start)
      let endPoint = calculate.barXGridlinePoint(using: increment, for: .end)
      
      if enableYGridVisibility == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
    }
  }
  
  
  /// Y Gridlines used by the horizontal bar graph
  func drawHorizontalYGridlines(on context: CGContext, using arrayCount: Int) {
    for increment in 0...arrayCount {
      let yStartPoint = calculate.yHorizontalGridline(using: increment, for: .start)
      let yEndPoint = calculate.yHorizontalGridline(using: increment, for: .end)
      drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
    }
  }
  
  /// X Gridlines used by the horizontal bar graph
  func drawHorizontalXGridlines(on context: CGContext, using gridline: Double) {
    for increment in 0...Int(gridline) {
      let startPoint = calculate.xHorizontalGridline(using: increment, for: .start )
      let endPoint = calculate.xHorizontalGridline(using: increment, for: .end)
      drawGridLines(context: context, start: startPoint, end: endPoint)
    }
  }

  
}





