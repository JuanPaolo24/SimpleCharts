//
//  HighlightRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class HighlightRenderer: UIView {
  
  var calculate = LineGraphCalculation()
  var offSet = offset(left: 0, right: 0, top: 0, bottom: 0)
  var lineCustomisationSource = LineChartData()
  var barCustomisationSource = BarChartData()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  
  

  
}
