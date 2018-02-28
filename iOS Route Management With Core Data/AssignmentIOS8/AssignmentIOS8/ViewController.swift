/*
 * Created by Prashanth Murali on 4/27/17.
 * Copyright © 2017 Prashanth Murali. All rights reserved.
 * Right To Use for the instructor and the University to build and evaluate the software package
 * @author Prashanth Murali mail to: pmurali10@asu.edu
 * @version 1.0 April 27, 2017
 */



import UIKit
import CoreData

class ViewController: UIViewController,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var places:[String:placeDescription] = [String:placeDescription]()
    var selectedPlace:String = ""
    var names:[String] = [String]()
    
    var pickedPlace:String = ""
    var aPlace:placeDescription = placeDescription()
    var DBEntity:String = "Place";
    
    var place = [NSManagedObject]()
    
    var DelObj:AppDelegate?
    var contextObj:NSManagedObjectContext?
    
    
    
    @IBOutlet weak var name1: UITextField!
    @IBOutlet weak var description1: UITextField!
    @IBOutlet weak var category1: UITextField!
    @IBOutlet weak var address_title1: UITextField!
    @IBOutlet weak var address_street1: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var elevation: UITextField!
    @IBOutlet weak var placePicker: UIPickerView!
    @IBOutlet weak var placeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let EditButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit , target: self, action: #selector(ViewController.editPlace))
        self.navigationItem.rightBarButtonItem = EditButton
        DelObj = (UIApplication.shared.delegate as! AppDelegate)
        contextObj = DelObj!.managedObjectContext
        
        self.Reload(selectedPlace)
        self.title="\(self.aPlace.name)"
        
        placeTF.text="\(self.aPlace.name)"
        placePicker.delegate = self
        placePicker.dataSource = self
        placeTF.inputView=placePicker
        
        self.navigationController?.delegate = self
    }
    
    @IBAction func displayButtonClicked(_ sender: Any) {
        
        name1.text = "\(aPlace.name)"
        description1.text = "\(aPlace.description)"
        category1.text = "\(aPlace.category)"
        address_title1.text = "\(aPlace.address_title)"
        address_street1.text = "\(aPlace.address_street)"
        elevation.text = "\(aPlace.elevation)"
        latitude.text = "\(aPlace.latitude)"
        longitude.text = "\(aPlace.longitude)"
        self.title = "\(aPlace.name)"
        selectedPlace=pickedPlace
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Reload(_ name: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntity)
        fetchRequest.predicate = NSPredicate(format: "name == %@",name)
        
        do{
            let response = try contextObj!.fetch(fetchRequest)
            if response.count > 0 {
                self.aPlace = placeDescription(
                    name: ((response[0] as AnyObject).value(forKey: "name") as? String)!,
                    latitude:((response[0] as AnyObject).value(forKey: "latitude") as? String)!,
                    longitude:((response[0] as AnyObject).value(forKey: "longitude") as? String)!,
                    elevation:((response[0] as AnyObject).value(forKey: "elevation") as? String)!,
                    address_title:((response[0] as AnyObject).value(forKey: "address_title") as? String)!,
                    address_street:((response[0] as AnyObject).value(forKey: "address_street") as? String)!,
                    description: ((response[0] as AnyObject).value(forKey: "desc") as? String)!,
                    category: ((response[0] as AnyObject).value(forKey: "category") as? String)!);
                
                
                
                self.name1.text = "\(self.aPlace.name)";
                self.description1.text = "\(self.aPlace.description)";
                self.category1?.text = "\(self.aPlace.category)";
                self.address_title1.text = "\(self.aPlace.address_title)";
                self.address_street1.text = "\(self.aPlace.address_street)";
                self.elevation.text = "\(self.aPlace.elevation)";
                self.latitude.text = "\(self.aPlace.latitude)";
                self.longitude.text = "\(self.aPlace.longitude)";
                self.title="\(self.aPlace.name)"
                
                
                
                self.placePicker.delegate = self
                self.placePicker.removeFromSuperview()
                self.placeTF.inputView = self.placePicker
                
            }
            
        } catch let error as NSError{
            
            NSLog("Error selecting place \(name). Error: \(error)")
            
        }    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == placePicker {
            let pickedPlace = place[row]
            self.placeTF.text = (pickedPlace.value(forKey: "name") as? String)!
            self.placeTF.resignFirstResponder()
            self.title="\(self.aPlace.name)"
            self.Reload(self.placeTF.text!)
            
        }
        
    }
    
    
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var returnValue:String?
        if(pickerView == placePicker){
            let pickedPlace = place[row]
            returnValue = pickedPlace.value(forKey: "name") as? String
        }
        return returnValue
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return place.count
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.placeTF.resignFirstResponder()

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeTF.resignFirstResponder()
        return true
    }
    
    
    
    func editPlace() {
        print("edit button clicked")
        
        
        let promptND = UIAlertController(title: "\(self.aPlace.name)", message: "Edit Place Details", preferredStyle: UIAlertControllerStyle.alert)
        
        promptND.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        promptND.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let newPlaceName="\(self.aPlace.name)"
            
            let newPlaceDesctiption:String = (promptND.textFields?[0].text == "") ?
                "Enter Description" : (promptND.textFields?[0].text)!
            self.aPlace.description=newPlaceDesctiption
            
            let newPlaceCategory:String = (promptND.textFields?[1].text == "") ?
                "Enter Category" : (promptND.textFields?[1].text)!
            self.aPlace.category=newPlaceCategory
            
            let newPlaceAddress_Title:String = (promptND.textFields?[2].text == "") ?
                "Enter Address-Title" : (promptND.textFields?[2].text)!
            self.aPlace.address_title=newPlaceAddress_Title
            
            let newPlaceAddress_Street:String = (promptND.textFields?[3].text == "") ?
                "Enter Address-Street" : (promptND.textFields?[3].text)!
            self.aPlace.address_street=newPlaceAddress_Street
            
            
            let newPlaceElevation:String = (promptND.textFields?[4].text == "") ?
                "Enter Elevation" : (promptND.textFields?[4].text)!
            self.aPlace.elevation=newPlaceElevation
            
            
            let newPlaceLatitude:String = (promptND.textFields?[5].text == "") ?
                "Enter Latitude" : (promptND.textFields?[5].text)!
            self.aPlace.latitude=newPlaceLatitude
            
            let newPlaceLongitude:String = (promptND.textFields?[6].text == "") ?
                "Enter Longitude" : (promptND.textFields?[6].text)!
            self.aPlace.longitude=newPlaceLongitude
            
            
            let aPlace:placeDescription = placeDescription(name: newPlaceName,latitude: newPlaceLatitude, longitude: newPlaceLongitude, elevation: newPlaceElevation, address_title: newPlaceAddress_Title, address_street: newPlaceAddress_Street, description: newPlaceDesctiption, category: newPlaceCategory)
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.DBEntity);
            fetchRequest.predicate = NSPredicate(format: "name == %@", aPlace.name);
            
            do{
                let response = try self.contextObj!.fetch(fetchRequest);
                if response.count > 0 {
                    let editObj:NSManagedObject = response[0] as! NSManagedObject;
                    editObj.setValue(aPlace.name, forKey: "name")
                    editObj.setValue(aPlace.description, forKey: "desc")
                    editObj.setValue(aPlace.category, forKey: "category")
                    editObj.setValue(aPlace.address_title, forKey: "address_title")
                    editObj.setValue(aPlace.address_street, forKey: "address_street")
                    editObj.setValue(aPlace.elevation, forKey: "elevation")
                    editObj.setValue(aPlace.latitude, forKey: "latitude")
                    editObj.setValue(aPlace.longitude, forKey: "longitude")
                    do{
                        try self.contextObj!.save()
                        
                    } catch let error as NSError{
                        NSLog("Error saving place \(aPlace.name). Error: \(error)")
                    }
                }
            } catch let error as NSError{
                NSLog("Error saving place \(aPlace.name). Error: \(error)")
            }
            self.Reload(aPlace.name);
            
        }))
        
        
        if description1.text != "Enter Description"
        {
            
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.description)"
            })
            
        }
            
        else
            
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Description"
            })
            
        }
        
        if category1.text != "Enter Category"
        {
            
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.category)"
            })
        }
            
        else
            
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Category"
            })
            
        }
        
        if address_title1.text != "Enter Address-Title"
        {
            
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.address_title)"
            })
        }
            
        else
        {
            
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Address-Title"
            })
            
        }
        
        
        if address_street1.text != "Enter Address-Street"
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.address_street)"
            })
        }
            
        else
        {
            
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Address-Street"
            })
        }
        
        
        if elevation.text != "Enter Elevation"
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.elevation)"
            })
        }
            
        else
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Elevation"
            })
        }
        
        if latitude.text != "Enter Latitude"
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.latitude)"
            })
        }
            
        else
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Latitude"
            })
            
        }
        
        if longitude.text != "Enter Longitude"
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = "\(self.aPlace.longitude)"
            })
        }
            
        else
        {
            promptND.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter Longitude"
            })
            
        }
        
        
        present(promptND, animated: true, completion: nil)
    }
    
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        
        print("entered navigationController willShow viewController")
        if let controller = viewController as? PlaceTableViewController {
            controller.places = self.places
            controller.tableView.reloadData()
        }
    }
}


