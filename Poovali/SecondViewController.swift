//
//  SecondViewController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlantRepository.findAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell", for: indexPath) as? PlantTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PlantTableViewCell.")
        }
        
        let plant = PlantRepository.findAll()[indexPath.row]
        cell.nameLabel.text = plant.name
        cell.contentLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("duration_days", comment: ""),
            plant.getCropDuration())
        
        cell.plantTypeImageView.image = UIImage(named:plant.imageResourceId)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

