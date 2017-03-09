//
//  PlantViewController.swift
//  Poovali
//
//  Created by anbu on 07/03/17.
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import os.log

class PlantViewController: UIViewController,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK: Properties
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var ripeningText: UITextField!
    @IBOutlet weak var fruitingText: UITextField!
    @IBOutlet weak var floweringText: UITextField!
    @IBOutlet weak var seedlingText: UITextField!
    @IBOutlet weak var plantNameText: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var plant:Plant?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantNameText.delegate = self
        ripeningText.delegate = self
        fruitingText.delegate = self
        floweringText.delegate = self
        seedlingText.delegate = self
        
        // Set up views if editing an existing plant.
        if let plant = plant {
            if plant.imageResourceId != nil {
                plantImageView.image = UIImage(named:plant.imageResourceId!)
            } else if plant.uiImage != nil {
                plantImageView.image = plant.uiImage!
            }
            navigationItem.title = plant.name
            plantNameText.text = plant.name
            floweringText.text = plant.growthStageMap[Plant.GrowthStage.Flowering]?.description
            seedlingText.text = plant.growthStageMap[Plant.GrowthStage.Seedling]?.description
            ripeningText.text = plant.growthStageMap[Plant.GrowthStage.Ripening]?.description
            fruitingText.text = plant.growthStageMap[Plant.GrowthStage.Fruiting]?.description
        }
        // Enable the Save button only if the text field has a valid plant name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateSaveButtonState()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        //navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        plantImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            fatalError("The PlantViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let seedling:Int? = Int(seedlingText.text!)
        let fruiting:Int? = Int(fruitingText.text!)
        let flowering:Int? = Int(floweringText.text!)
        let ripening:Int? = Int(ripeningText.text!)
        
        //if seedling != nil && fruiting != nil && flowering != nil && ripening != nil{
        if plant != nil {
            plant!.name = plantNameText.text!
            plant!.uiImage = plantImageView.image
            plant!.growthStageMap[Plant.GrowthStage.Flowering] = flowering
            plant!.growthStageMap[Plant.GrowthStage.Seedling] = seedling
            plant!.growthStageMap[Plant.GrowthStage.Ripening] = ripening
            plant!.growthStageMap[Plant.GrowthStage.Fruiting] = fruiting
            
        } else {
            plant = Plant(id:PlantRepository.nextPlantId(),
                          name:plantNameText.text!,
                          imageResourceId:nil,
                          uiImage:plantImageView.image,
                          seedling:seedling!,
                          flowering:flowering!,
                          fruiting:fruiting!,
                          ripening:ripening!)
        }
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        plantNameText.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = !(plantNameText.text!.isEmpty || ripeningText.text!.isEmpty || fruitingText.text!.isEmpty || floweringText.text!.isEmpty || seedlingText.text!.isEmpty)
    }
}
