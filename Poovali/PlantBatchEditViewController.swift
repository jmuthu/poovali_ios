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
        saveButton.isEnabled = false
    }
    
    func duplicateCheck(_ datePicker: UIDatePicker) {
        let plant:Plant?
        if plantBatch == nil {
            plant = PlantRepository.findAll()[plantListPickerView.selectedRow(inComponent: 0)]
        } else {
            plant = plantBatch!.plant
        }
        let dupPlantBatch = plant?.findBatch(inputDate: datePicker.date)
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
        return 1    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return PlantRepository.findAll().count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView{
        let plant = PlantRepository.findAll()[row]
        let myView = UIView(frame: CGRect(x:0, y:0, width:pickerView.bounds.width, height:24))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:24, height:24))
        if plant.imageResourceId != nil {
            myImageView.image = UIImage(named:plant.imageResourceId!)
        } else if plant.uiImage != nil {
            myImageView.image = plant.uiImage!
        } else {
            myImageView.image = UIImage(named:"plant")
        }
        
        let myLabel = UILabel(frame: CGRect(x:40, y:0, width:pickerView.bounds.width, height:24 ))
        //myLabel.font = UIFont.preferredFont(forTextStyle:UIFontTextStyle.subheadline)
        myLabel.text = plant.name
        
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
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //if seedling != nil && fruiting != nil && flowering != nil && ripening != nil{
        if plantBatch != nil {
            plantBatch!.createdDate = createdDatePicker.date
            plantBatch!.desc = notesTextView.text
        } else {
            let plant = PlantRepository.findAll()[plantListPickerView.selectedRow(inComponent: 0)]
            plantBatch = PlantBatch(id:PlantBatchRepository.nextPlantBatchId(),
                                    name:"",
                                    plantId:0,
                                    createdDate:createdDatePicker.date,
                                    description:notesTextView.text)
            plantBatch!.plant = plant
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        plantBatch!.name  = plantBatch!.plant!.name + " - " + dateFormatter.string(from: createdDatePicker.date)
    }
    
    //MARK: Actions
    
    //MARK: Private Methods
    
}
