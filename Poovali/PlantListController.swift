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
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return PlantRepository.findAll()[indexPath.row].plantBatchList.count == 0
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PlantRepository.delete(plant:PlantRepository.findAll()[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
        Helper.setImage(uIImageView: cell.plantTypeImageView, plant: plant)
                
        if plant.plantBatchList.isEmpty {
            cell.lastBatchDateLabel.text = ""
            cell.nextBatchDueLabel.text = ""
        } else {
            cell.nameLabel.text! += " (" + plant.plantBatchList.count.description + ")"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let plantBatch = plant.getLatestBatch()!
            cell.lastBatchDateLabel.text  = String.localizedStringWithFormat(
                NSLocalizedString("Last sowed", comment: ""),
                dateFormatter.string(from: plantBatch.createdDate))
            
            Helper.setOverDueText(labelView:cell.nextBatchDueLabel, due:plant.pendingSowDays())
        }
        
        return cell
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddPlant":
            if #available(iOS 10.0, *) {
                os_log("Adding a new plant.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            
        case "ShowDetail":
            guard let plantDetailViewController = segue.destination as? PlantDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPlantCell = sender as? PlantTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPlantCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            plantDetailViewController.plant = PlantRepository.findAll()[indexPath.row]
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Actions
    
    @IBAction func savePlant(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PlantEditViewController, let plant = sourceViewController.plant {
            PlantRepository.store(plant:plant)
        }
    }
    
    @IBAction func deletePlant(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PlantDetailViewController, let plant = sourceViewController.plant {
            PlantRepository.delete(plant:plant)
        }
    }
}

