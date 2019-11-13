//
//  FirstViewController.swift
//  Billsify
//
//  Created by Lisbet Meneses on 10/11/2019.
//  Copyright © 2019 Lisbet Meneses. All rights reserved.
//

import UIKit
import CoreData
import Charts

class BillsBriefViewController: UIViewController {
    
    @IBOutlet var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let bills = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "Bills"))
            var categories: [String] = []
            var amount: [Double] = []
            for bill in bills {
                let bill_category = (bill as! Bills).category!
                if (!categories.contains(bill_category)) {
                    categories.append(bill_category)
                    amount.append((bill as! Bills).amount)
                } else {
                    let i = categories.firstIndex(of: bill_category)!
                    amount[i] += (bill as! Bills).amount
                }
            }

            customizeChart(dataPoints: categories, values: amount.map{ Double($0) })
        } catch{
            print ("Failed request")
        }
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
      // 2. Set ChartDataSet
      let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
      format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
      pieChartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}

