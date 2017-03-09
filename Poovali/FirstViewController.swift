//
//  FirstViewController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlantBatchRepository.findAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantBatchTableViewCell", for: indexPath) as? PlantBatchTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlantBatchTableViewCell.")
        }
        
        let plantBatch = PlantBatchRepository.findAll()[indexPath.row]
        cell.nameLabel.text = plantBatch.name
        cell.batchStatusLabel.text = String(describing: plantBatch.getStage())
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.eventCreateDateLabel.text  = dateFormatter.string(from: plantBatch.latestEventCreatedDate)
        if !plantBatch.eventList.isEmpty {
            let event = plantBatch.eventList.first!
            cell.eventDescriptionLabel.text = event.description.isEmpty ? event.getName(): event.description
            cell.eventTypeImageView.image = UIImage(named:event.getImageResourceId())
        } else {
            cell.eventTypeImageView.image = UIImage(named:"sow")
            cell.eventDescriptionLabel.text = NSLocalizedString("Sow", comment:"")
        }
        cell.circularProgressView.angle = Double(plantBatch.getProgressInPercent())*3.6
        if plantBatch.plant.imageResourceId != nil {
            cell.plantTypeImageView.image = UIImage(named:plantBatch.plant.imageResourceId!)
        } else if plantBatch.plant.uiImage != nil {
            cell.plantTypeImageView.image = plantBatch.plant.uiImage
        } else {
            cell.plantTypeImageView.image = UIImage(named:"plant")
        }
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

