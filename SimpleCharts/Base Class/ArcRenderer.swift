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
    fatalError("init(coder:) has not been implemented")
  }
  

  func drawPieArc(context: CGContext, radiusPercentage: CGFloat, segments: PieChartDataSet) {
    
    let radius = min(frame.size.width, frame.size.height) * radiusPercentage
    let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
    let valueCount = segments.array.reduce(0, {$0 + $1.value})
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: 12.0), foreGroundColor: UIColor.black)
    
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
