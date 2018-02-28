/*
 * Created by Prashanth Murali on 4/27/17.
 * Copyright © 2017 Prashanth Murali. All rights reserved.
 * Right To Use for the instructor and the University to build and evaluate the software package
 * @author Prashanth Murali mail to: pmurali10@asu.edu
 * @version 1.0 April 27, 2017
 */

import Foundation
import UIKit
import CoreData

class PlaceTableViewController : UITableViewController {
    
    var places:[String:placeDescription] = [String:placeDescription]()
    var names:[String] = [String]()
    var flag:Int = 0
    var DBEntity:String = "Place";
    var PlaceList = [NSManagedObject]()
    
    var DelObj:AppDelegate?
    var contextObj:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad")
        
        DelObj = (UIApplication.shared.delegate as! AppDelegate)
        contextObj = DelObj!.managedObjectContext
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(PlaceTableViewController.addPlace))
        self.navigationItem.rightBarButtonItem = addButton
        self.fetchDB();
        self.ReloadTable()
        self.title = "Places List"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func ReloadTable() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntity)
        do{
            let response = try contextObj!.fetch(fetchRequest)
            
            PlaceList = response as! [NSManagedObject]
            var i:Int = 0;
            self.names.removeAll();
            while i < PlaceList.count {
                self.names.append((PlaceList[i].value(forKey: "name") as? String)!);
                i += 1;
            }
            self.tableView.reloadData()
        } catch let error as NSError{
            NSLog("Error selecting all places: \(error)")
        }
    }
    
    
    func addPlace() {
        print("add button clicked")
        
        
        let promptND = UIAlertController(title: "New Place", message: "Enter Place Name & Details", preferredStyle: UIAlertControllerStyle.alert)
        
        promptND.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        promptND.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            var newPlaceName:String = (promptND.textFields?[0].text == "") ?
                "None" : (promptND.textFields?[0].text)!
            let newPlaceDesctiption:String = (promptND.textFields?[1].text == "") ?
                "Enter Description" : (promptND.textFields?[1].text)!
            let newPlaceCategory:String = (promptND.textFields?[2].text == "") ?
                "Enter Category" : (promptND.textFields?[2].text)!
            let newPlaceAddress_Title:String = (promptND.textFields?[3].text == "") ?
                "Enter Address-Title" : (promptND.textFields?[3].text)!
            let newPlaceAddress_Street:String = (promptND.textFields?[4].text == "") ?
                "Enter Address-Street" : (promptND.textFields?[4].text)!
            
            let newPlaceElevation:String = (promptND.textFields?[5].text == "") ?
                "Enter Elevation" : (promptND.textFields?[5].text)!
            let newPlaceLatitude:String = (promptND.textFields?[6].text == "") ?
                "Enter Latitude" : (promptND.textFields?[6].text)!
            let newPlaceLongitude:String = (promptND.textFields?[7].text == "") ?
                "Enter Longitude" : (promptND.textFields?[7].text)!
            
            if newPlaceName == "None"
            {
                
                let alert = UIAlertController(title: "ERROR: Place Name Missing", message: "Enter a Place Name", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
                    self.tableView.reloadData()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                self.flag = 1
            }
            
            
            if(self.names.count>0)
            {
                for i in 0...self.names.count-1
                {
                    if newPlaceName==self.names[i]
                    {
                        
                        let alert = UIAlertController(title: "ERROR: Invalid Place Name", message: "Enter a New Place Name", preferredStyle: .alert)
                        
                        
                        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
                            self.tableView.reloadData()
                        }))
                        
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        self.flag = 1
                        
                    }
                }
            }
            
            
            if self.flag == 0
                
            {
                let aPlace:placeDescription = placeDescription(name: newPlaceName,latitude: newPlaceLatitude, longitude: newPlaceLongitude, elevation: newPlaceElevation, address_title: newPlaceAddress_Title, address_street: newPlaceAddress_Street, description: newPlaceDesctiption, category: newPlaceCategory)
                
                let entity = NSEntityDescription.entity(forEntityName: self.DBEntity, in: self.contextObj!)
                let aPlaceEntity = NSManagedObject(entity: entity!, insertInto: self.contextObj)
                aPlaceEntity.setValue(aPlace.name, forKey: "name")
                aPlaceEntity.setValue(aPlace.description, forKey: "desc")
                aPlaceEntity.setValue(aPlace.category, forKey: "category")
                aPlaceEntity.setValue(aPlace.address_title, forKey: "address_title")
                aPlaceEntity.setValue(aPlace.address_street, forKey: "address_street")
                aPlaceEntity.setValue(aPlace.elevation, forKey: "elevation")
                aPlaceEntity.setValue(aPlace.latitude, forKey: "latitude")
                aPlaceEntity.setValue(aPlace.longitude, forKey: "longitude")
                do{
                    try self.contextObj!.save()
                    self.ReloadTable()
                } catch let error as NSError{
                    NSLog("Error adding place \(aPlace.name). Error: \(error)")
                }
            }
            self.flag = 0
        }))
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Name"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Description"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Category"
        })
        
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Address Title"
        })
        
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Address Street"
        })
        
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Elevation"
        })
        
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Latitude"
        })
        
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Longitude"
        })
        
        
        present(promptND, animated: true, completion: nil)
    }
    
    
    func fetchDB(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntity)
        do{
            let response = try contextObj!.fetch(fetchRequest)
            if response.count == 0 {
                let entity = NSEntityDescription.entity(forEntityName:self.DBEntity, in:self.contextObj!)
                let placeEntity = NSManagedObject(entity:entity!,insertInto:self.contextObj)
                placeEntity.setValue("ASU-West",forKey: "name")
                placeEntity.setValue("Home of ASU's Applied Computing Program", forKey: "desc")
                placeEntity.setValue("School", forKey: "category")
                placeEntity.setValue("ASU West Campus", forKey: "address_title")
                placeEntity.setValue("13591 N 47th Ave$Phoenix AZ 85051", forKey: "address_street")
                placeEntity.setValue("1100.0", forKey: "elevation")
                placeEntity.setValue("33.608979", forKey: "latitude")
                placeEntity.setValue("-112.159469", forKey: "longitude")
                do{
                    try self.contextObj!.save()
                    self.ReloadTable()
                    
                } catch let error as NSError{
                    NSLog("Error adding place \(""). Error: \(error)")
                }
            }
            
        } catch let error as NSError{
            NSLog("Error selecting all places: \(error)")
        }
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing row at: \(indexPath.row)")
        if editingStyle == .delete {
            let selectedPlace:String = names[indexPath.row]
            print("deleting the student \(selectedPlace)")
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntity)
            fetchRequest.predicate = NSPredicate(format: "name == %@", selectedPlace)
            do{
                let response = try contextObj!.fetch(fetchRequest)
                if response.count > 0 {
                    contextObj!.delete(response[0] as! NSManagedObject)
                    try contextObj?.save()
                }
            } catch let error as NSError{
                NSLog("error selecting all students \(error)")
            }
            ReloadTable()
            
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        cell.textLabel?.text = self.names[indexPath.row]
        cell.detailTextLabel?.text = "\(self.PlaceList[indexPath.row].value(forKey: "category")!)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("seque identifier is \(String(describing: segue.identifier))")
        if segue.identifier == "switchscreen" {
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.place = self.PlaceList
            viewController.selectedPlace = self.names[indexPath.row]
        }
    }
    
    
    
    
    
}

