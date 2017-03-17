//
//  ActivityEditViewController.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log


class ActivityEditViewController: UIViewController,  UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate{
    
    //MARK: Properties
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityListPickerView: UIPickerView!
    @IBOutlet weak var createdDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var event:Event!
    var plantBatch:PlantBatch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTextView.delegate = self
        activityListPickerView.delegate = self
        createdDatePicker.maximumDate = Date()
        
        // Set up views if editing an existing plant batch.
        if let event = event {
            activityLabel.removeFromSuperview()
            activityListPickerView.removeFromSuperview()
            navigationItem.title = event.getName()
            notesTextView.text = event.desc
            createdDatePicker.date = event.createdDate
            plantBatch = PlantBatchRepository.find(batchId:event.batchId)
        }
        createdDatePicker.minimumDate = plantBatch!.createdDate
        createdDatePicker.addTarget(self, action: #selector(ActivityEditViewController.duplicateCheck(_:)), for: UIControlEvents.valueChanged)
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.cornerRadius = 5
        saveButton.isEnabled = false
    }
    
    func duplicateCheck(_ datePicker: UIDatePicker) {
        let name :String
        if event == nil {
            let type = BatchActivityEvent.ActivityType(rawValue: UInt8(activityListPickerView.selectedRow(inComponent: 0)))!
            name = NSLocalizedString(String(describing: type), comment: "")
        } else {
            name = event.getName()
        }
        let dupEvent = plantBatch?.findEvent(name: name, inputDate: datePicker.date)
        if dupEvent != nil && !(dupEvent?.sameIdentityAs(other: event))! {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("Duplicate event", comment:""), preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: UIAlertActionStyle.default)
            {
                (action : UIAlertAction) -> Void in
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
        return BatchActivityEvent.ActivityType.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView{
        let type:BatchActivityEvent.ActivityType = BatchActivityEvent.ActivityType.allValues[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width:pickerView.bounds.width, height:24))
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:24, height:24))
        
        myImageView.image = UIImage(named:String(describing: type).lowercased())
        
        let myLabel = UILabel(frame: CGRect(x:40, y:0, width:pickerView.bounds.width, height:24 ))
        myLabel.text = NSLocalizedString(String(describing: type), comment: "")
        
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
            fatalError("The ActivityEditViewController is not inside a navigation controller.")
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
        if event != nil {
            event!.createdDate = createdDatePicker.date
            event!.desc = notesTextView.text
        } else {
            let type = BatchActivityEvent.ActivityType(rawValue: UInt8(activityListPickerView.selectedRow(inComponent: 0)))!
            event = BatchEventFactory.createEvent(type: type, createdDate: createdDatePicker.date, description: notesTextView.text, batchId: plantBatch.id)
        }
    }
    
    //MARK: Actions
    
    //MARK: Private Methods
    

}
