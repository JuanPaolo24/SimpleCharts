//
//  RendererHelper.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 18/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


class RendererHelper {
  
  
  /// Takes in multiple arrays and determines the highest value within all arrays and returns it
  open func processMultipleArrays(array: [[Double]]) -> Double {
    var max = 0.0
    var newArray: [Double] = []
    
    for i in array {
      if let maxValue = i.max() {
        newArray.append(maxValue)
      }
    }
    
    if let newMax = newArray.max() {
      max = newMax
    }
    
    return max + 41
  }
  
  /// Takes in multiple arrays and determines the array with the highest count and returns that count
  open func findArrayCount(array: [[Double]]) -> Int {
    var arrayCount = 0
    var newArray: [Int] = []
    
    for i in array {
      newArray.append(i.count)
    }
    
    if let newMax = newArray.max() {
      arrayCount = newMax
    }
    
    return arrayCount
    
  }

  // Calculates the increment diagonally. The initial value takes in consideration the initial padding which is 31 and then calculates the remaining space available to ensure that it does not go over the edge.
  open func calculatexValue(frameWidth: Double, arrayCount: Double, distanceIncrement: Int, initialValue: Double) -> Double{
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / (arrayCount - 1)
    
    let xValue = initialValue + (increment * Double(distanceIncrement))
    
    return xValue
    
  }
  

  
  /// Class for creating text labels
  open func createLabel(text: String, textFrame: CGRect) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let attributes: [NSAttributedString.Key : Any] = [
      .paragraphStyle: paragraphStyle,
      .font: UIFont.systemFont(ofSize: 8.0),
      .foregroundColor: UIColor.black
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    attributedString.draw(in: textFrame)
    
  }
  
  /// Converts the chart data into double
  func convert(chartData: [ChartData]) -> [[Double]] {
    var array: [[Double]] = [[]]
    for i in 0...chartData.count-1 {
      array.append(chartData[i].array)
    }
    array.removeFirst()
    return array
  }
  
}
