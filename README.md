# SimpleCharts

SimpleCharts is a re-implementation of the famous iOS charting solution [Charts](https://github.com/danielgindi/Charts) for
my final year project. The goal of the project is to simplify and improve the implementation of ”Charts” through a minimalist 
approach. It also gives a chance to learn about the inner workings of iOS development frameworks. The approach was not to try 
and beat “Charts” since it was already established, but to provide a simpler option for developers that do not necessarily 
need specific configurations and would prefer an easier time implementing.


## Installation

To use the library:
1. Drag the `SimpleCharts.xcodeproj` to your project.
2. Add the framework to your Embedded Binaries by going to the target's settings and under the Embedded Binaries section click
on the + sign.
3. Select Simple Charts on the menu.
4. To access the library on your source code; simply add `Import SimpleCharts` on top of your source code file.
5. Refer to the documentation section below to learn how to use the library.

## Sample Usage

The following are just the basic configuration of the charts. To learn more about the other customisation option refer to the
[wiki](https://github.com/JuanPaolo24/SimpleCharts/wiki) for more information. 

### Creating a simple Line Chart

```Swift
Import SimpleCharts

let chartView = LineChartView()
let values: [Double] = [100, 212, 32, 230, 430]
let entryArray = LineChartData(dataset: values, datasetName: "Test")
let dataSet = LineChartDataSet(dataset: [entryArray])
chartView.lineType = .normal
chartView.data = dataSet
```
#### Output
![Alt text](SampleUsage/sampleusageline.png?raw=true "Normal Line Chart")

To change it to a bezier graph just change lineType to:

```Swift
chartView.lineType = .bezier
```
#### Output
![Alt text](SampleUsage/sampleusagebezier.png?raw=true "Bezier Line Chart")

### Creating a simple Bar Chart

```Swift
Import SimpleCharts

let chartView = BarChartView()
let values: [Double] = [100, 212, 32, 230, 430]
let entryArray = BarChartData(dataset: values, datasetName: "Test")
let dataSet = BarChartDataSet(dataset: [entryArray])
chartView.barOrientation = .vertical
chartView.data = dataSet
```
#### Output
![Alt text](SampleUsage/sampleusagevertical.png?raw=true "Vertical Bar Chart")

To change it to a horizontal graph just change barOrientation to:

```Swift
chartView.barOrientation = .horizontal
```
#### Output
![Alt text](SampleUsage/sampleusagehorizontal.png?raw=true "Horizontal Bar Chart")

### Creating a simple Combine Chart

```Swift
Import SimpleCharts

let chartView = CombineChartView()
let lineValues: [Double] = [50, 124, 40, 32, 64]
let barValues: [Double] = [100, 212, 130, 230, 430]
let lineEntry = LineChartData(dataset: lineValues, datasetName: "LineChart")
let barEntry = BarChartData(dataset: barValues, datasetName: "BarChart")
let lineDataSet = LineChartDataSet(dataset: [lineEntry])
let barDataSet = LineChartDataSet(dataset: [barEntry])
let combinedDataSet = CombinedChartDataSet(lineData: lineDataSet, barData: barDataSet)
chartView.data = combinedDataSet
```
#### Output
![Alt text](SampleUsage/sampleusagecombine.png?raw=true "Combine Chart")

### Creating a simple Pie Chart

```Swift
Import SimpleCharts

let chartView = PieChartView()
let data1 = PieChartData(color: UIColor.red, value: 30, name: "Data1")
let data2 = PieChartData(color: UIColor.blue, value: 50, name: "Data2")
let data3 = PieChartData(color: UIColor.yellow, value: 100, name: "Data3")
let data4 = PieChartData(color: UIColor.green, value: 30, name: "Data4")
let dataSet = PieChartDataSet(dataset: [data1, data2, data3, data4])
chartView.data = dataSet
```
#### Output
![Alt text](SampleUsage/sampleusagepie.png?raw=true "Pie Chart")

## Features

- Support the creation of Line Charts, Bar Charts, Pie Charts and Combined Chart (Line and Bar)
- Support for Line Gradient
- Support for Horizontal Bar Charts
- Support for Negative Values
- Customisable Axis (both x and y axis)
- Customisable Legends 
- Highlights
- Animation (Line, Bar and Combined)

## Screenshots
Some of the things you can create with the library

### Normal Line Chart
![Alt text](Screenshots/linechart.png?raw=true "Normal Line Chart")

### Bezier Line Chart
![Alt text](Screenshots/beziercurve.png?raw=true "Bezier Line Chart")

### Vertical Bar Chart
![Alt text](Screenshots/verticalbargraph.png?raw=true "Vertical Bar Chart")

### Horizontal Bar Chart
![Alt text](Screenshots/horizontalbargraph.png?raw=true "Horizontal Bar Chart")

### Combine Chart
![Alt text](Screenshots/combinechart.png?raw=true "Combine Chart")

### Pie Chart
![Alt text](Screenshots/piechart.png?raw=true "Pie Chart")


## Contributing

Starting June 1st 2019, pull requests are welcome. Refer to the issue page first to highlight the change that you are proposing 
and discuss the change. 

## License
[MIT](https://choosealicense.com/licenses/mit/)
