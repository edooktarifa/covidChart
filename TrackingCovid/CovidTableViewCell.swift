//
//  CovidTableViewCell.swift
//  TrackingCovid
//
//  Created by Lawencon on 14/07/20.
//  Copyright © 2020 Lawencon. All rights reserved.
//

import UIKit
import Charts

class CovidTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lineChartViews: LineChartView!{
        didSet{
            //            lineChartView.fitScreen()
            lineChartViews.extraRightOffset = 23
            lineChartViews.extraLeftOffset = 23
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChart1(dataPoints: [String], values: [Double], provience: [String]) {
        var dataEntries: [ChartDataEntry] = []
        
        let tanggalTransaksi = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let semuaTanggal = provience
        
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Sales Volume")
        chartDataSet.circleRadius = 5
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.colors = [NSUIColor.blue]
        chartDataSet.circleColors = [NSUIColor.blue]
        chartDataSet.drawValuesEnabled = true
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 2.0
        
        let gradient = getGradientFilling()
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.usesGroupingSeparator = true
        
        let chartData = LineChartData(dataSets: [chartDataSet])
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        lineChartViews.data = chartData
        
        lineChartViews.drawGridBackgroundEnabled = false
        lineChartViews.leftAxis.drawAxisLineEnabled = true
        lineChartViews.rightAxis.drawAxisLineEnabled = true
        lineChartViews.legend.enabled = true
        lineChartViews.leftAxis.enabled = false
        lineChartViews.rightAxis.enabled = false
        //
        lineChartViews.xAxis.valueFormatter = IndexAxisValueFormatter(values: semuaTanggal)
        lineChartViews.xAxis.labelPosition = .bottom
        
        lineChartViews.xAxis.labelFont = UIFont.init(name: "AvenirNext-Regular", size: 8)!
        lineChartViews.contentMode = .scaleToFill
        
        lineChartViews.xAxis.spaceMin = 0.2
        lineChartViews.xAxis.spaceMax = 0.2
    
    }
    
    private func getGradientFilling() -> CGGradient {
        let coloTop = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1).cgColor
        
        let gradientColors = [coloTop] as CFArray
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
}
