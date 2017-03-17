//
//  PlantDetailViewController.swift
//  Poovali
//

//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log
import Charts

class PlantDetailViewController: UIViewController{
    //MARK: Properties
    var plant:Plant?
    var isBatchListEditing: Bool = false
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var batchLabel: UILabel!
    @IBOutlet weak var batchContainerView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var plantImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.holeRadiusPercent = 0.4
        chartView.transparentCircleRadiusPercent = 0.45
        
        chartView.drawCenterTextEnabled = true
        chartView.setExtraOffsets(left: 0, top: 15, right: 0, bottom: 5)
        chartView.drawEntryLabelsEnabled = false
        chartView.highlightPerTapEnabled = true
        chartView.rotationEnabled = false
        chartView.animate(yAxisDuration: 1.400, easingOption:ChartEasingOption.easeInOutQuad)
        chartView.chartDescription = nil
        chartView.centerTextOffset = CGPoint(x: 0, y: 25)
        let l = chartView.legend
        l.enabled = true
        l.verticalAlignment = Legend.VerticalAlignment.bottom
        l.horizontalAlignment = Legend.HorizontalAlignment.right
        l.orientation = Legend.Orientation.vertical
        l.formSize = 10
        l.form = Legend.Form.circle
        l.drawInside = true
        l.wordWrapEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSubViews()
    }
    
    func setSubViews() {
        if let plant = plant {
            navigationItem.title = plant.name
            Helper.setImage(uIImageView:plantImageView,plant:plant)
            setBatchLabel()
            if !plant.plantBatchList.isEmpty {
                Helper.setOverDueText(labelView:durationLabel, due:plant.pendingSowDays())
            }
            var entries = [PieChartDataEntry]()
            for stage in Plant.GrowthStage.stages {
                entries.append(PieChartDataEntry(value:Double(plant.growthStageMap[stage]!),
                                                 label:NSLocalizedString(String(describing: stage), comment:"")))
            }
            
            let dataSet = PieChartDataSet(values: entries, label: "")
            dataSet.setColors(NSUIColor.red, NSUIColor.orange, NSUIColor.yellow, NSUIColor.green)
            dataSet.sliceSpace = 3
            dataSet.yValuePosition = PieChartDataSet.ValuePosition.insideSlice
            let data = PieChartData(dataSet:dataSet)
            data.setValueFont(NSUIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote))
            let formatter = NumberFormatterExt()
            data.setValueFormatter(formatter)
            data.setValueTextColor(NSUIColor.black)
            
            chartView.centerText = String.localizedStringWithFormat(NSLocalizedString("duration_days", comment: ""),
                                                                    plant.getCropDuration())
            chartView.data = data
        }
    }
    
    func setBatchLabel() {
        batchLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("batches", comment: ""),
            plant?.plantBatchList.count ?? 0)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        if isBatchListEditing {
            isBatchListEditing = false
            editButton.setTitle(NSLocalizedString("Edit", comment:""),for: .normal)
        } else {
            isBatchListEditing = true
            editButton.setTitle(NSLocalizedString("Done", comment:""),for: .normal)
        }
        let tableView = batchContainerView.subviews[0] as? UITableView
        tableView!.isEditing = isBatchListEditing
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddPlantBatch":
            guard let destinationNavigationController = segue.destination as? UINavigationController,
                let batchEditViewController = destinationNavigationController.topViewController as? PlantBatchEditViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            batchEditViewController.plant = plant
            
        case "EditDetail":
            guard let plantEditViewController = segue.destination as? PlantEditViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            plantEditViewController.plant = plant
            
        case "embedPlantBatch" :
            guard let plantBatchListController = segue.destination as? PlantBatchListController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            plantBatchListController.plant = plant
        
        case "unwindDeletePlant":
            break
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func savePlant(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PlantEditViewController, let plant = sourceViewController.plant {
            PlantRepository.store(plant:plant)
            setSubViews()
        }
    }
    
    @IBAction func deletePlant(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("Delete plant", comment:""), preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default)
        {
            (action : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "unwindDeletePlant", sender: self)
        }
        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
