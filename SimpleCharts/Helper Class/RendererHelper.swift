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
  
  /// Returns the max value from an array
  open func returnMaxValueFrom(array: [Double]) -> Double {
    var max = 0.0
    if let maxValue = array.max() {
      max = maxValue
    }
    return max + 41
  }
  
  
  /// Takes in multiple arrays and within those array determine the array with the highest count and returns that count
  open func findArrayCountFrom(array: [[Double]]) -> Int {
    var arrayCount = 0
    var countArray: [Int] = []
    
    for i in array {
      countArray.append(i.count)
    }
    
    if let newMax = countArray.max() {
      arrayCount = newMax
    }
    
    return arrayCount
  }

  
  // Calculates the increment diagonally. The initial value takes in consideration the initial padding which is 31 and then calculates the remaining space available to ensure that it does not go over the edge.
  open func calculatexValueIncrement(frameWidth: Double, arrayCount: Double, distanceIncrement: Int, initialValue: Double) -> Double{
    let spaceLeft = frameWidth - (initialValue * 2)
    let increment = spaceLeft / (arrayCount - 1)
    let xValue = initialValue + (increment * Double(distanceIncrement))
    
    return xValue
    
  }
  
  // Similar function to calculatexValueIncrement but instead of returning values based on array count, this is based on a fix value which is 6
  
  open func calculatexValueSpace(frameWidth: Double, arrayCount: Double, distanceIncrement: Int, initialValue: Double) -> Double {
    let spaceLeft = frameWidth - (initialValue * 2)
    var increment = 0.0
    
    if arrayCount < 6 {
      increment = spaceLeft / (arrayCount - 1)
    } else {
      increment = spaceLeft / 6
    }
    
    let xValue = initialValue + (increment * Double(distanceIncrement))
    
    return xValue
  }
  
  

  
  /// Function for rendering text in the view
  open func renderText(text: String, textFrame: CGRect) {
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
  
  
  /// Converts the an array of chart data into an array of array doubles
  open func convert(chartData: [ChartData]) -> [[Double]] {
    var array: [[Double]] = []
    for i in 0...chartData.count-1 {
      array.append(chartData[i].array)
    }
    return array
  }
  
  /// Converts chart data into an array of doubles
  open func convert(chartData: ChartData) -> [Double] {
    var array: [Double] = []
    for i in 0...chartData.array.count-1 {
      array.append(chartData.array[i])
    }
    return array
  }
  
}
