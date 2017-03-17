//
//  PlantBatchEditViewController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log


class PlantBatchEditViewController: UIViewController,  UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate{
    //MARK: Properties
    
    @IBOutlet weak var plantListPickerView: UIPickerView!
    @IBOutlet weak var createdDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var plantBatchLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var plantBatch:PlantBatch?
    var plant:Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTextView.delegate = self
        plantListPickerView.delegate = self
        createdDatePicker.maximumDate = Date()
        
        // Set up views if editing an existing plant batch.
        if let plantBatch = plantBatch {
            plantBatchLabel.removeFromSuperview()
            plantListPickerView.removeFromSuperview()
            navigationItem.title = plantBatch.name
            notesTextView.text = plantBatch.desc
            createdDatePicker.date = plantBatch.createdDate
            if (!plantBatch.eventList.isEmpty) {
                createdDatePicker.maximumDate = plantBatch.eventList.last?.createdDate.getStartOfDay()
            }
        }
        createdDatePicker.addTarget(self, action: #selector(PlantBatchEditViewController.duplicateCheck(_:)), for: UIControlEvents.valueChanged)
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.cornerRadius = 5
        saveButton.isEnabled = false
    }
    
    func duplicateCheck(_ datePicker: UIDatePicker) {
        let selectedPlant:Plant?
        if plant != nil {
            selectedPlant = plant
        } else if plantBatch == nil {
            selectedPlant = PlantRepository.findAll()[plantListPickerView.selectedRow(inComponent: 0)]
        } else {
            selectedPlant = plantBatch!.plant
        }
        let dupPlantBatch = selectedPlant?.findBatch(inputDate: datePicker.date)
        if dupPlantBatch != nil && !(dupPlantBatch?.sameIdentityAs(other: plantBatch))! {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("Duplicate batch", comment:""), preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default)
            {
                (action : UIAlertAction) -> Void in
                //self.performSegue(withIdentifier: "unwindDeletePlantBatch", sender: self)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if plant != nil {
            return 1
        }
        return PlantRepository.findAll().count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView{
        let pickerPlant:Plant
        if plant != nil {
            pickerPlant = plant!
        } else {
            pickerPlant = PlantRepository.findAll()[row]
        }
        let myView = UIView(frame: CGRect(x:0, y:0, width:pickerView.bounds.width, height:24))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:24, height:24))
        Helper.setImage(uIImageView: myImageView, plant: pickerPlant)
                
        let myLabel = UILabel(frame: CGRect(x:40, y:0, width:pickerView.bounds.width, height:24 ))
        //myLabel.font = UIFont.preferredFont(forTextStyle:UIFontTextStyle.subheadline)
        myLabel.text = pickerPlant.name
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        return myView
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PlantBatchEditViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            if #available(iOS 10.0, *) {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return
        }
        
        //if seedling != nil && fruiting != nil && flowering != nil && ripening != nil{
        if plantBatch != nil {
            plantBatch!.createdDate = createdDatePicker.date
            plantBatch!.desc = notesTextView.text
        } else {
            let selectedPlant:Plant
            if plant == nil {
                selectedPlant = PlantRepository.findAll()[plantListPickerView.selectedRow(inComponent: 0)]
            } else {
                selectedPlant = plant!
            }
            plantBatch = PlantBatch(id:PlantBatchRepository.nextPlantBatchId(),
                                    plant:selectedPlant,
                                    createdDate:createdDatePicker.date,
                                    description:notesTextView.text)
        }
    }
    
    //MARK: Actions
    
    //MARK: Private Methods
    
}
