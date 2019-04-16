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

  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
  }
  
  
  func testBinarySearchFunction() {
    let helper = HelperFunctions()
    let sampleArray = [CGPoint(x: 30, y: 50), CGPoint(x: 50, y: 100), CGPoint(x: 100, y: 500), CGPoint(x: 150, y: 400)]
    let binarySearch = helper.findClosest(array: sampleArray, target: CGPoint(x: 35, y: 530))
    let endBinary = helper.findClosest(array: sampleArray, target: CGPoint(x: 140, y: 200))
    
    XCTAssertEqual(binarySearch, CGPoint(x: 30, y: 50))
    XCTAssertEqual(endBinary, CGPoint(x: 150, y: 400))
    
  }

  func testCombineArrayFunction() {
    let helper = HelperFunctions()
    let array = [[20.0,30.0,55.0,65.0,100.0],[30.0,40.0,70.0]]
    
    let result = helper.combineArray(array: array)
    
    XCTAssertEqual(result, [20.0,30.0,30.0,40.0,55.0,65.0,70.0,100.0])
    
  }
  
  func testCombinedCGPointArrayFunction() {
    let helper = HelperFunctions()
    let array = [CGPoint(x: 60, y: 50), CGPoint(x: 50, y: 100), CGPoint(x: 100, y: 500), CGPoint(x: 150, y: 400)]
    let result = helper.combineCGPointArray(array: array)
    
    XCTAssertEqual(result, [CGPoint(x: 50, y: 100), CGPoint(x: 60, y: 50), CGPoint(x: 100, y: 500), CGPoint(x: 150, y: 400)])
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
