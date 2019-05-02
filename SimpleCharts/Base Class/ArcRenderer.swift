//
//  ArcRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class ArcRenderer: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    isOpaque = false
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  

  func drawPieArc(on context: CGContext, using segments: PieChartDataSet, with centerX: CGFloat, and centerY: CGFloat) {
    
    let radius = min(frame.size.width, frame.size.height) * segments.setRadius
    let viewCenter = CGPoint(x: centerX, y: centerY)
    let valueCount = segments.array.reduce(0, {$0 + $1.value})
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 12.0, weight: .bold), foreGroundColor: UIColor(red:0.65, green:0.65, blue:0.65, alpha:1.0))
    var startAngle = -CGFloat.pi * 0.5
    
    for segment in segments.array {
      context.setFillColor(segment.color.cgColor)
      
      let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
      let halfAngle = startAngle + (endAngle - startAngle) * 0.5
      let labelPosition = CGFloat(0.8)
      let labelXPosition = viewCenter.x + (radius * labelPosition) * cos(halfAngle)
      let labelYPosition = viewCenter.y + (radius * labelPosition) * sin(halfAngle)
      context.move(to: viewCenter)
      context.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
      context.fillPath()
      textRenderer.renderText(text: "\(segment.value)", textFrame: CGRect(x: labelXPosition, y: labelYPosition , width: 40, height: 20))
      startAngle = endAngle
    
    }
    
  }
  
  
  
}
