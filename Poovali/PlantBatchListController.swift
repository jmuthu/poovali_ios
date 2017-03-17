//
//  PlantBatchListController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log

class PlantBatchListController: UITableViewController {
    var plant:Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if plant != nil {
            return plant!.plantBatchList.count
        }
        return PlantBatchRepository.findAll().count
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if plant != nil {
            return plant!.plantBatchList[indexPath.row].eventList.count == 0
        }
        return PlantBatchRepository.findAll()[indexPath.row].eventList.count == 0
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plantBatch:PlantBatch
            if plant != nil {
                plantBatch = plant!.plantBatchList[indexPath.row]
            } else {
                plantBatch = PlantBatchRepository.findAll()[indexPath.row]
            }
            plantBatch.plant.deleteBatch(plantBatch: plantBatch)
            PlantBatchRepository.delete(plantBatch:plantBatch)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantBatchTableViewCell", for: indexPath) as? PlantBatchTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlantBatchTableViewCell.")
        }
        let plantBatch:PlantBatch
        if plant != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            plantBatch = plant!.plantBatchList[indexPath.row]
            cell.nameLabel.text = dateFormatter.string(from:plantBatch.createdDate)
        } else {
            plantBatch = PlantBatchRepository.findAll()[indexPath.row]
            cell.nameLabel.text = plantBatch.name
        }
        
        cell.batchStatusLabel.text = NSLocalizedString(String(describing: plantBatch.getStage()), comment:"")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.eventCreateDateLabel.text  = dateFormatter.string(from: plantBatch.latestEventCreatedDate)
        if !plantBatch.eventList.isEmpty {
            let event = plantBatch.eventList.first!
            cell.eventDescriptionLabel.text = event.desc.isEmpty ? event.getName(): event.desc
            cell.eventTypeImageView.image = UIImage(named:event.getImageResourceId())
        } else {
            cell.eventTypeImageView.image = UIImage(named:"sow")
            cell.eventDescriptionLabel.text = NSLocalizedString("Sow", comment:"")
        }
        cell.circularProgressView.angle = Double(plantBatch.getProgressInPercent())*3.6
        if plant != nil {
            cell.plantTypeImageView.image = nil
        } else {
            Helper.setImage(uIImageView: cell.plantTypeImageView, plant: plantBatch.plant)
        }
        return cell
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddPlantBatch":
            if #available(iOS 10.0, *) {
                os_log("Adding a new plant batch.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            
        case "ShowDetail":
            guard let plantBatchDetailViewController = segue.destination as? PlantBatchDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPlantBatchCell = sender as? PlantBatchTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPlantBatchCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            if plant != nil {
                plantBatchDetailViewController.plantBatch = plant?.plantBatchList[indexPath.row]
            } else {
                plantBatchDetailViewController.plantBatch = PlantBatchRepository.findAll()[indexPath.row]
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    //MARK: Actions
    
    @IBAction func savePlantBatch(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PlantBatchEditViewController, let plantBatch = sourceViewController.plantBatch {
            plantBatch.plant.addOrUpdatePlantBatch(plantBatch: plantBatch)
            PlantBatchRepository.store(plantBatch:plantBatch)
        }
    }
    
    @IBAction func deletePlantBatch(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PlantBatchDetailViewController, let plantBatch = sourceViewController.plantBatch {
            plantBatch.plant.deleteBatch(plantBatch: plantBatch)
            PlantBatchRepository.delete(plantBatch:plantBatch)
        }
    }
}

