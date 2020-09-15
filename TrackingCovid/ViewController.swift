//
//  ViewController.swift
//  TrackingCovid
//
//  Created by Lawencon on 11/07/20.
//  Copyright © 2020 Lawencon. All rights reserved.
//

import UIKit
import Alamofire
import Charts

class ViewController: BaseViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!{
        didSet{
            //            lineChartView.fitScreen()
            lineChartView.extraRightOffset = 23
            lineChartView.extraLeftOffset = 23
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var province : [String] = []
    
    var dataJSON = [CovidModel]()
    
    var showData : [showDataModel] = []
    
    var x1 = [5,20, 30, 40, 50,20, 30, 40, 50]
    var x2 = [30,40, 20, 30, 45, 40, 20, 30, 45]
    var x3 = [5, 10, 20, 30, 45, 10, 20, 30, 45]
    var value = ["j", "k", "l", "m", "n", "o", "p", "q", "r"]
    
    
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading
    }

    override func viewWillAppear(_ animated: Bool) {
        showData = []
        runTimer()
        self.showSpinner(onView: self.view)
        fetchData()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let hour = dateFormatter.string(from: date)
        dateLbl.text = "Jakarta, \(hour)"

    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
        timerLabel.text = "Timer: \(timeString(time: TimeInterval(seconds)))"
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func fetchData(){
        var propinsi : [String] = []
        var meninggal = [Int]()
        var dataSembuh = [Int]()
        var dataPositif = [Int]()
        
        propinsi = []
        meninggal = []
        dataSembuh = []
        dataPositif = []
        
        Alamofire.request("https://api.kawalcorona.com/indonesia/provinsi", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{
            
            response in
            
            switch response.result{
            case .success:
                self.timer.invalidate()
                self.removeSpinner()
                if let jsonData = response.data{
                    self.province = []
                    let jsonDecoder = JSONDecoder()
                    do{
                        let covidData = try jsonDecoder.decode([CovidModel].self, from: jsonData)
                        //                        print(workOut)
                        self.dataJSON = covidData
                        
                    
                        for data in covidData{
                            
                            self.showData.append(showDataModel.init(nama: data.attributes?.provinsi ?? "", meninggal: data.attributes?.kasus_Meni ?? 0, positif: data.attributes?.kasus_Posi ?? 0
                                , sembuh: data.attributes?.kasus_Semb ?? 0))
                        }
                        
                       
                        
                        let datas = self.showData.map{$0.nama}
                        let value = self.showData.map{($0.meninggal)}
                        let sembuh = self.showData.map{($0.sembuh)}
                        let positif = self.showData.map{($0.positif)}
                        
                        propinsi.append(datas[0])
                        propinsi.append(datas[1])
                        propinsi.append(datas[2])
                        propinsi.append(datas[3])
                        propinsi.append(datas[4])
                        
                        meninggal.append(value[0])
                        meninggal.append(value[1])
                        meninggal.append(value[2])
                        meninggal.append(value[3])
                        meninggal.append(value[4])
                        
                        dataSembuh.append(sembuh[0])
                        dataSembuh.append(sembuh[1])
                        dataSembuh.append(sembuh[2])
                        dataSembuh.append(sembuh[3])
                        dataSembuh.append(sembuh[4])
                        
                        dataPositif.append(positif[0])
                        dataPositif.append(positif[1])
                        dataPositif.append(positif[2])
                        dataPositif.append(positif[3])
                        dataPositif.append(positif[4])
                        
                        
//                        self.setChart1(dataPoints: propinsi, values: [1.0, 2.0, 1.0, 2.0,3.0], provience: propinsi)
                        let gradient = self.getGradientFilling()
                        
                        let data = LineChartData()
                        var lineChartEntry1 = [ChartDataEntry]()
                        
                        for i in 0..<meninggal.count {
                            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(meninggal[i]) ))
                        }
                        let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Meninggal")
                        line1.colors = [.blue]
                        data.addDataSet(line1)
                        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
                        line1.drawFilledEnabled = true
                        line1.drawValuesEnabled = true
                        line1.mode = .cubicBezier
                        line1.lineWidth = 2.0
                        
                        if (dataPositif.count > 0) {
                            var lineChartEntry2 = [ChartDataEntry]()
                            for i in 0..<dataPositif.count {
                                lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(dataPositif[i]) ))
                            }
                            let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Positif")
                            line2.circleColors = [.orange]
                            line2.colors = [.orange]
                            data.addDataSet(line2)
                            line2.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
                            line2.drawFilledEnabled = true
                            line2.drawValuesEnabled = true
                            line2.mode = .cubicBezier
                            line2.lineWidth = 2.0
                            
                        }
                        if (dataSembuh.count > 0) {
                            var lineChartEntry3 = [ChartDataEntry]()
                            for i in 0..<dataSembuh.count {
                                lineChartEntry3.append(ChartDataEntry(x: Double(i), y: Double(dataSembuh[i]) ))
                            }
                            let line3 = LineChartDataSet(entries: lineChartEntry3, label: "Sembuh")
                            line3.circleColors = [UIColor.red]
                            line3.colors = [.red]
                            data.addDataSet(line3)
                            line3.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
                            line3.drawFilledEnabled = true
                            line3.drawValuesEnabled = true
                            line3.mode = .cubicBezier
                            line3.lineWidth = 2.0
                        }
                        self.lineChartView.data = data
                        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:propinsi)
                        self.lineChartView.xAxis.granularity = 1
                        self.lineChartView.xAxis.labelPosition = .bottom
                        
                        self.lineChartView.drawGridBackgroundEnabled = false
                        self.lineChartView.legend.enabled = true
                        self.lineChartView.backgroundColor = .groupTableViewBackground
                        self.lineChartView.animate(yAxisDuration: 1.0)
                        print(self.showData)
                    }catch{
                        
                    }
                }
            case .failure(let error):
                self.timer.invalidate()
                self.removeSpinner()
                print(error)
            }
            
        }
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
        
        lineChartView.data = chartData
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.rightAxis.drawAxisLineEnabled = true
        lineChartView.legend.enabled = true
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        //
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: provience)
        lineChartView.xAxis.labelPosition = .bottom
        
        lineChartView.xAxis.labelFont = UIFont.init(name: "AvenirNext-Regular", size: 8)!
        lineChartView.contentMode = .scaleAspectFit
        
        lineChartView.xAxis.spaceMin = 0.2
        lineChartView.xAxis.spaceMax = 0.2
        
    }
    
    private func getGradientFilling() -> CGGradient {
        let coloTop = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1).cgColor
        
        let gradientColors = [coloTop] as CFArray
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    
    @IBAction func reloadData(_ sender: UIButton){
        timerLabel.text = "Timer: 00:00:00"
        seconds = 0
        runTimer()
        self.showSpinner(onView: self.view)
        fetchData()
    }
}


struct showDataModel {
    var nama: String
    var meninggal: Int
    var positif: Int
    var sembuh: Int
}
