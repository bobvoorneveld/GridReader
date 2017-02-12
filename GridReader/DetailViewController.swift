//
//  DetailViewController.swift
//  GridReader
//
//  Created by Bob Voorneveld on 11/02/2017.
//  Copyright © 2017 Purple Gorilla. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController {

    @IBOutlet weak var chartView: BarChartView!

    var household: Household? {
        didSet {
            configureView()
        }
    }

    var logs: [EnergyLog]? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        title = household?.address
        guard let logs = logs else { return }

        var consumed: [BarChartDataEntry] = []
        var produced: [BarChartDataEntry] = []

        for (i, log) in logs.enumerated() {
            let consumedEntry = BarChartDataEntry(x: Double(i), y: Double(log.consumed))
            consumed.append(consumedEntry)
            let producedEntry = BarChartDataEntry(x: Double(i), y: Double(log.produced))
            produced.append(producedEntry)
        }

        let consumedSet = BarChartDataSet(values: consumed, label: "Consumed")
        consumedSet.colors = consumed.map { _ in UIColor.red }
        let producedSet = BarChartDataSet(values: produced, label: "Produced")
        producedSet.colors = produced.map { _ in UIColor.green }

        let data = BarChartData(dataSets: [consumedSet, producedSet])
        data.groupBars(fromX: 0.0, groupSpace: 0.0, barSpace: 0.0)
        chartView.data = data
        chartView.chartDescription?.text = nil
        chartView.legend.enabled = false
    }

    func downloadLogs() {
        Webservice.load(resource: household!.allLogs()) { result in
            if case let .success(objects) = result, let logs = objects {
                DispatchQueue.main.async {
                    self.logs = logs
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        downloadLogs()
    }
}

