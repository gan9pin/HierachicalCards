//
//  ChartController.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/16.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit
import PNChartSwift

class ChartController:UIViewController {
    
    @IBOutlet weak var chartView: UIScrollView!
    @IBOutlet weak var chartFrame: UIView!
    
    let topMargin:CGFloat = 40
    var mode = 0
    let timeTransitive = 0
    let totalStudyTime = 1
    
    override func viewDidLoad() {
        
    }
    func timeTransitiveLineChart(){
        
        let colors = ["#c93a40","#de9610","#a0c238","#56a764","#0074bf","#9460a0"]
        
        let subjects = SubjectDBHelper.findAll()
        var x_datas: [String] = []
        var y_datas: [[Double]] = []
        let span:Double = 7
        for sub in subjects!{
            let lineChartData = StudyTimeDBHelper.studyTimeLog(sub.name, span: span)
            x_datas = lineChartData.date
            y_datas += [lineChartData.time]
        }
        let max:CGFloat = CGFloat(maxValue(y_datas))
        var count = 0
        for ydata in y_datas{
            lineChart(x_datas, ydata: ydata.map{CGFloat($0)},yValueMax: max,xLabelStep: CGFloat(ceil(span/10.0)),color: colors[count])
            count++
        }
    }
    
    func totalStudyTimeBarChart(){
        let subjects = SubjectDBHelper.findAll()
        let x_data = SubjectDBHelper.getSubjectNames(subjects!)
        let y_data = SubjectDBHelper.getStudyTimes(subjects!)
        barChart(x_data, ydata: y_data.map{CGFloat($0)})
    }
    
    func lineChart(xdata:[String],ydata:[CGFloat],yValueMax:CGFloat,xLabelStep: CGFloat,color:String){
        
//        let ChartLabel:UIButton = UIButton(frame: CGRectMake(0, 0, 320.0, 30))
        
//        ChartLabel.setTitleColor(PNGreenColor,forState: .Normal)
//        ChartLabel.titleLabel!.font = UIFont(name: "Avenir-Medium", size:23.0)
//        ChartLabel.addTarget(self, action: "changeChart", forControlEvents: .TouchUpInside)
//        ChartLabel.setTitle("グラフ切り替え", forState: .Normal)
        print(xdata.count)
        var chartWidth:CGFloat = CGFloat(xdata.count * 20)
        if(chartWidth < chartView.bounds.width){
            chartWidth = chartView.bounds.width
        }
        
        self.chartView.contentSize = CGSizeMake(chartWidth, 0)
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, topMargin, chartWidth, chartFrame.frame.height - self.topLayoutGuide.length - self.bottomLayoutGuide.length))
        lineChart.yLabelFormat = "%.1fh"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xLabelStep = xLabelStep
        lineChart.xLabels = xdata
        lineChart.showCoordinateAxis = true
        
        var data01Array: [CGFloat] = ydata
        let data01:PNLineChartData = PNLineChartData()
        data01.color = UIColor.hexStr(color, alpha: 1.0)
        data01.itemCount = data01Array.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            let yValue:CGFloat = data01Array[index]
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        //座標を定める
        lineChart.chartData = [data01]
        
        //最大値の比率で表示したい場合はchartDataをセットしたあとにyValueMin,yValueMaxをセットすることに注意
        lineChart.yValueMin = 0
        lineChart.yValueMax = yValueMax
        
        lineChart.yLabelsCount = 5  //yLabelsの値自体は関係なく、その要素数だけ分割されてlabelが表示される
        
        lineChart.strokeChart() //strokeChartは最後
        
        chartView.addSubview(lineChart)
//        chartView.addSubview(ChartLabel)

    }
    func barChart(xdata:[String],ydata:[CGFloat]){
        let ChartLabel:UIButton = UIButton(frame: CGRectMake(0, 0, 320.0, 30))
        
        ChartLabel.setTitleColor(PNGreenColor,forState: .Normal)
        ChartLabel.titleLabel!.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.addTarget(self, action: "changeChart", forControlEvents: .TouchUpInside)
        ChartLabel.setTitle("Change", forState: .Normal)
        
        let barChart = PNBarChart(frame: CGRectMake(0, topMargin, chartFrame.bounds.width, chartFrame.frame.height - topMargin))
        barChart.backgroundColor = UIColor.clearColor()
        barChart.yLabelFormatter = ({(yValue: CGFloat) -> NSString in
            let yValueParsed:CGFloat = yValue
            let labelText:NSString = NSString(format:"%.1fh",yValueParsed)
            return labelText;
        })
        
        
        // animationタイプ
        barChart.animationType = .Waterfall
        
        
        barChart.labelMarginTop = 5.0
        barChart.xLabels = xdata
        barChart.yValues = ydata
        barChart.yValueMax = ceil(ydata.maxElement()!)
        barChart.strokeChart()
        
        //        barChart.delegate = self
        
        chartView.addSubview(ChartLabel)
        chartView.addSubview(barChart)
        
        self.title = "Bar Chart"
    }
    func changeChart(){
        if(mode == timeTransitive){
            removeAllSubviews(self.chartView)
            mode = totalStudyTime
            totalStudyTimeBarChart()
        }else if(mode == totalStudyTime){
            removeAllSubviews(self.chartView)
            mode = timeTransitive
            timeTransitiveLineChart()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        removeAllSubviews(chartView)
        if(mode == timeTransitive){
            timeTransitiveLineChart()
        }else if(mode == totalStudyTime){
            totalStudyTimeBarChart()
        }
        
        // 端末の向きがかわったらNotificationを呼ばす設定.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    // 端末の向きがかわったら呼び出される.
    func onOrientationChange(notification: NSNotification){
        
        removeAllSubviews(chartView)
        if(mode == timeTransitive){
            timeTransitiveLineChart()
        }else if(mode == totalStudyTime){
            totalStudyTimeBarChart()
        }
        
    }
    
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func maxValue(values:[[Double]]) -> Double{
        var max: Double = 0.0
        for valueArray in values{
            for value in valueArray{
                if(max < value){
                    max = value
                }
            }
        }
        return max
    }
    
}
