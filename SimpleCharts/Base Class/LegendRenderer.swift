//
//  LegendRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 18/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class LegendRenderer: ChartRenderer {
  
  let helper = RendererHelper()
  
  /// Renders the legend - Chart Type is between (Line, Bar and Pie)
  func renderLegend(context: CGContext, chartType: String) {
    
    let width = frameWidth()
    
    let rectangleLegend = CGRect(x: width - 50, y: 20, width: 10, height: 10)
    
    if chartType == "Line" {
      context.setFillColor(UIColor.black.cgColor)
    } else {
      context.setFillColor(UIColor.black.cgColor)
    }
    context.setLineWidth(1.0)
    context.addRect(rectangleLegend)
    context.drawPath(using: .fill)
    
    let textFrame = CGRect(x: width - 35, y: 15, width: 30, height: 20)
    
    helper.createLabel(text: "Dataset 1", textFrame: textFrame)
    
    
  }
  
  
}
