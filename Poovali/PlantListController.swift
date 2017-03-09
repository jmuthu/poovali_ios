//
//  PlantListController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log

class PlantListController: UITableViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlantRepository.findAll().count
    }
    
    //MARK: - Navigation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell", for: indexPath) as? PlantTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlantTableViewCell.")
        }
        
        let plant = PlantRepository.findAll()[indexPath.row]
        cell.nameLabel.text = plant.name
        cell.contentLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("duration_days", comment: ""),
            plant.getCropDuration())
        if plant.imageResourceId != nil {
            cell.plantTypeImageView.image = UIImage(named:plant.imageResourceId!)
        } else if plant.uiImage != nil {
            cell.plantTypeImageView.image = plant.uiImage
        } else {
            cell.plantTypeImageView.image = UIImage(named:"plant")
        }
        
        if !plant.plantBatchList.isEmpty {
            cell.nameLabel.text! += " (" + plant.plantBatchList.count.description + ")"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let plantBatch = plant.getLatestBatch()!
            cell.lastBatchDateLabel.text  = String.localizedStringWithFormat(
                NSLocalizedString("Last sowed", comment: ""),
                dateFormatter.string(from: plantBatch.createdDate))
            
            setOverDueText(labelView:cell.nextBatchDueLabel, due:plant.pendingSowDays())
        }
        
        return cell
    }
    
    func setOverDueText(labelView:UILabel, due:Int){
        var format:String
        if due > 0 {
            labelView.textColor = UIColor.orange;
            format = NSLocalizedString("sow_over_due", comment:"")
        } else {
            format = NSLocalizedString("sow_next", comment:"")
        }
        labelView.text = String.localizedStringWithFormat(format, abs(due))
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddPlant":
            os_log("Adding a new plant.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let plantViewController = segue.destination as? PlantViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPlantCell = sender as? PlantTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPlantCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            plantViewController.plant = PlantRepository.findAll()[indexPath.row]
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToPlantList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PlantViewController, let plant = sourceViewController.plant {
            PlantRepository.store(plant:plant)
            tableView.reloadData()
            /*
             if let selectedIndexPath = tableView.indexPathForSelectedRow {
             // Update an existing plant.
             PlantRepository.store(plant:plant)
             tableView.reloadRows(at: [selectedIndexPath], with: .none)
             }
             else {
             // Add a new plant.
             let newIndexPath = IndexPath(row: PlantRepository.findAll().count, section: 0)
             tableView.insertRows(at: [newIndexPath], with: .automatic)
             }
             */
        }
    }
}

