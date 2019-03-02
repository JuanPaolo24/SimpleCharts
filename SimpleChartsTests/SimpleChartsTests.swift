//
//  SimpleChartsTests.swift
//  SimpleChartsTests
//
//  Created by Juan Paolo  Del Rosario on 28/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import XCTest
@testable import SimpleCharts

class SimpleChartsTests: XCTestCase {
  
  var chartRenderer: ChartRenderer!
  var array: [Double]!
  var max: Double!
  var calcPortrait: LineGraphCalculation!
  var calcLandscape: LineGraphCalculation!
  
  override func setUp() {
    chartRenderer = ChartRenderer()
    array = [8.0, 104.0, 81.0, 93.0, 52.0, 44.0, 97.0, 101.0, 75.0, 28.0,
             76.0, 25.0, 20.0, 13.0, 52.0, 44.0, 57.0, 23.0, 45.0, 91.0,
             99.0, 14.0, 84.0, 48.0, 40.0, 71.0, 106.0, 41.0, 45.0, 61.0]
    max = array.max()! + 41
    calcPortrait = LineGraphCalculation(array: array, maxValue: max, initialValue: 31, frameWidth: 414, frameHeight: 673)
    calcLandscape = LineGraphCalculation(array: array, maxValue: max, initialValue: 70, frameWidth: 896, frameHeight: 300)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
  }
  
  func testLineGraphStartingYPoint() {
    let portraitbaseLine = 577.748299319728
    let landscapebaseLine = 225.04761904761904
    
    let portrait = calcPortrait.ylineGraphStartPoint()
    let landscape = calcLandscape.ylineGraphStartPoint()
    XCTAssertEqual(portrait, portraitbaseLine, "Starting Y value not the same")
    XCTAssertEqual(landscape, landscapebaseLine, "Starting Y value not the same")
    
  }
  
  func testLineGraphStartingXPoint() {
    let portraitbaseLine = 31.0
    let landscapebaseLine = 70.0
    
    let portrait = calcPortrait.xlineGraphStartPoint()
    let landscape = calcLandscape.xlineGraphStartPoint()
    XCTAssertEqual(portrait, portraitbaseLine, "Starting X value not the same")
    XCTAssertEqual(landscape, landscapebaseLine, "Starting X value not the same")
    
  }
  
  func testPortraitLineGraphYPoint() {
    let expectedResults = [577.748299319728, 178.7278911564626, 274.3265306122449, 224.44897959183675, 394.8639455782313, 428.1156462585034, 207.82312925170066, 191.19727891156464, 299.265306122449, 494.6190476190476, 295.10884353741494, 507.08843537414964, 527.8707482993198, 556.9659863945578, 394.8639455782313, 428.1156462585034, 374.0816326530612, 515.4013605442177, 423.9591836734694, 232.76190476190476, 199.51020408163265, 552.8095238095239, 261.8571428571429, 411.48979591836735, 444.74149659863946, 315.89115646258506, 170.41496598639458, 440.5850340136054, 423.9591836734694, 357.4557823129252]
    
    
    for (i, value) in array.enumerated() {
      let portrait = calcPortrait.ylineGraphPoint(value: value)
      XCTAssertEqual(portrait, expectedResults[i], "Y values not the same")
    }
  }
  
  func testLandscapeLineGraphYPoint() {
    let expectedResults = [225.04761904761904, 69.61904761904762, 106.85714285714286, 87.42857142857142, 153.8095238095238, 166.76190476190476, 80.95238095238096, 74.47619047619048, 116.57142857142857, 192.66666666666666, 114.95238095238095, 197.52380952380952, 205.61904761904762, 216.95238095238096, 153.8095238095238, 166.76190476190476, 145.71428571428572, 200.76190476190476, 165.14285714285714, 90.66666666666666, 77.71428571428572, 215.33333333333334, 102.0, 160.28571428571428, 173.23809523809524, 123.04761904761905, 66.38095238095238, 171.61904761904762, 165.14285714285714, 139.23809523809524]
    
    
    for (i, value) in array.enumerated() {
      let landscape = calcLandscape.ylineGraphPoint(value: value)
      XCTAssertEqual(landscape, expectedResults[i], "Y values not the same")
    }
  }
  
  
  
  func testPortraitLineGraphXPoint() {
    let expectedResults = [70.0, 96.06896551724138, 122.13793103448276, 148.20689655172413, 174.27586206896552, 200.34482758620692, 226.41379310344828, 252.48275862068965, 278.55172413793105, 304.62068965517244, 330.68965517241384, 356.7586206896552, 382.82758620689657, 408.89655172413796, 434.9655172413793, 461.0344827586207, 487.1034482758621, 513.1724137931035, 539.2413793103449, 565.3103448275863, 591.3793103448277, 617.448275862069, 643.5172413793103, 669.5862068965517, 695.6551724137931, 721.7241379310345, 747.7931034482759, 773.8620689655173, 799.9310344827586, 826.0]
    
    
    for i in 0...array.count - 1 {
      let landscape = calcLandscape.xlineGraphPoint(i: i)
      XCTAssertEqual(landscape, expectedResults[i], "Y values not the same")
    }    
  }
  
  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
