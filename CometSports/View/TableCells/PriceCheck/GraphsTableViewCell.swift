//
//  GraphsTableViewCell.swift
//  Comet Sports
//
//  Created by iosDev on 7/29/23.
//

import UIKit
import DGCharts

class GraphsTableViewCell: UITableViewCell {

    @IBOutlet weak var barChartTitleLBL: UILabel!
    @IBOutlet weak var lineChartTitleLBL: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var barChart: BarChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}

extension GraphsTableViewCell:ChartViewDelegate{
    
}

protocol GraphsCellDelegate{
    func updateBarGraph(data:[String:Int])
    func updateLineGraph(numbers:[Float])
}

extension GraphsTableViewCell:GraphsCellDelegate{
    func updateLineGraph(numbers: [Float]) {
        var lineChartEntry = [ChartDataEntry]()
        for (index,item) in numbers.enumerated() {
            lineChartEntry.append(ChartDataEntry(x: Double(index), y: Double(item)))
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Prices")
        let data = LineChartData(dataSet: line1)
        lineChartTitleLBL.text = "Pricing with respect to time".localized
        lineChart.data=data
        lineChart.xAxis.labelTextColor = .white
        lineChart.leftAxis.labelTextColor = .white
        lineChart.fitScreen()
        lineChart.xAxis.labelPosition = .bottom
        lineChart.pinchZoomEnabled=false
        lineChart.rightAxis.enabled=false
        lineChart.animate(xAxisDuration: 0.5, easingOption: .easeInBack )
        lineChart.noDataText = "No chart data available.".localized
        
    }
    
    func updateBarGraph(data: [String : Int]) {
        var dataEntries : [BarChartDataEntry] = []
        var count = 0
        let filterData:[String:Int] = findXBiggestEntries(in: data, x: 6)
        filterData.forEach{key,data in
            dataEntries.append(BarChartDataEntry(x: Double(count) , y: Double(data)))
            count = count+1
        }
        let barChartDataSet=BarChartDataSet(entries: dataEntries)
        let barData=BarChartData(dataSet: barChartDataSet)
        barChart.data=barData
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map{$0.key})
        barChartTitleLBL.text = "Category Frequency related to your search".localized
        barChart.xAxis.labelTextColor = UIColor.white
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelRotationAngle = 90
        barChart.leftAxis.labelTextColor = UIColor.white
        barChart.legend.textColor = UIColor.white
        barChart.rightAxis.enabled=false
        barChart.pinchZoomEnabled=false
        barChart.fitBars=true
        barChart.noDataText = "No chart data available.".localized
        barChart.animate(yAxisDuration: 0.5 , easingOption: .easeOutBounce)
    }
    
   
    
    func findXBiggestEntries(in dictionary: [String: Int], x: Int) -> [String: Int] {
        let sortedEntries = dictionary.sorted { $0.value > $1.value }
        
        var result: [String: Int] = [:]
        for (key, value) in sortedEntries.prefix(x) {
            result[key] = value
        }
        
        return result
    }
}
