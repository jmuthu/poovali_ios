//
//  PlantBatchDetailViewController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log

class PlantBatchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var growthStageLabel: UILabel!
    @IBOutlet weak var stageProgress: KDCircularProgress!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var activityTableView: UITableView!
    var plantBatch:PlantBatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTableView.delegate = self
        activityTableView.dataSource = self
        
        editButton.setTitle(NSLocalizedString("Edit", comment:""),for: .normal)
        /*
        borderView.layer.borderWidth = 0.4
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowOpacity = 0.7
        borderView.layer.shadowRadius = 3.0
        borderView.layer.shadowOffset = CGSize(width:1, height:1)
        
        activityTableView.layer.borderWidth = 0.4
        activityTableView.layer.borderColor = UIColor.lightGray.cgColor
        activityTableView.layer.shadowColor = UIColor.black.cgColor
        activityTableView.clipsToBounds = false
        activityTableView.layer.masksToBounds = false
        activityTableView.layer.shadowOpacity = 0.7
        activityTableView.layer.shadowRadius = 3.0
        activityTableView.layer.shadowOffset = CGSize(width:1, height:1)
        */
        setSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setSubViews() {
        if let plantBatch = plantBatch {
            navigationItem.title = plantBatch.plant.name
            descriptionLabel.text = plantBatch.desc
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            createdDateLabel.text  = String.localizedStringWithFormat(
                NSLocalizedString("age", comment: ""),
                plantBatch.getDurationInDays()) + String.localizedStringWithFormat(
                    NSLocalizedString("Created on date", comment: ""),
                    dateFormatter.string(from: plantBatch.createdDate))
            
            growthStageLabel.text = String(describing: plantBatch.getStage())
            stageProgress.angle = Double(plantBatch.getProgressInPercent())*3.6
            Helper.setImage(uIImageView: plantImageView, plant: plantBatch.plant)
            setActivityLabel()
        }
    }
    
    func setActivityLabel() {
        activitiesLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("activities", comment: ""),
            plantBatch?.eventList.count ?? 0)
    }
    
    //Mark - Activity Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantBatch!.eventList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as? ActivityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ActivityTableViewCell.")
        }
        
        let event = plantBatch!.eventList[indexPath.row]
        cell.nameLabel.text = event.getName()
        cell.descriptionLabel.text = event.desc
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.createdDateLabel.text  = dateFormatter.string(from: event.createdDate)
        cell.eventImageView.image = UIImage(named:event.getImageResourceId())
        
        return cell
    }
    
    @IBAction func editClicked(_ sender: Any) {
        if activityTableView.isEditing {
            activityTableView.isEditing = false
            editButton.setTitle(NSLocalizedString("Edit", comment:""),for: .normal)
        } else {
            activityTableView.isEditing = true
            editButton.setTitle(NSLocalizedString("Done", comment:""),for: .normal)
        }
    }
    
    // support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = plantBatch!.eventList[indexPath.row]
            plantBatch?.deleteEvent(event: event)
            EventRepository.delete(event:event)
            activityTableView.deleteRows(at: [indexPath], with: .fade)
            setActivityLabel()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddActivity":
            guard let destinationNavigationController = segue.destination as? UINavigationController,
                let activityEditViewController = destinationNavigationController.topViewController as? ActivityEditViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            activityEditViewController.plantBatch = plantBatch

        case "EditActivityDetail":
            guard let activityEditViewController = segue.destination as? ActivityEditViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedActivityCell = sender as? ActivityTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = activityTableView.indexPath(for: selectedActivityCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            activityEditViewController.event = plantBatch!.eventList[indexPath.row]
            activityEditViewController.plantBatch = plantBatch
    
        case "EditDetail":
            guard let plantBatchEditViewController = segue.destination as? PlantBatchEditViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            plantBatchEditViewController.plantBatch = plantBatch
        
        case "unwindDeletePlantBatch":
            break
        
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func savePlantBatch(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? PlantBatchEditViewController, let plantBatch = sourceViewController.plantBatch {
            plantBatch.plant.addOrUpdatePlantBatch(plantBatch: plantBatch)
            PlantBatchRepository.store(plantBatch:plantBatch)
            setSubViews()
        }
    }

    @IBAction func deletPlantBatch(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("Delete batch", comment:""), preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default)
        {
            (action : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "unwindDeletePlantBatch", sender: self)
        }
        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveActivity(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ActivityEditViewController, let event = sourceViewController.event {
            plantBatch?.addOrUpdateEvent(event: event)
            EventRepository.store(event:event)
            activityTableView.reloadData()
            setActivityLabel()
        }
    }
}
