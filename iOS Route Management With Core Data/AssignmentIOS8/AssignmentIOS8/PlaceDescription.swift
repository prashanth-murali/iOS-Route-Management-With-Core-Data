/*
 * Created by Prashanth Murali on 4/27/17.
 * Copyright © 2017 Prashanth Murali. All rights reserved.
 * Right To Use for the instructor and the University to build and evaluate the software package
 * @author Prashanth Murali mail to: pmurali10@asu.edu
 * @version 1.0 April 27, 2017
 */

import Foundation

class placeDescription{
    var name: String
    var latitude: String
    var longitude: String
    var elevation: String
    var address_title: String
    var address_street: String
    var description: String
    var category: String
    
    public init(){
        self.address_title = ""
        self.address_street = ""
        self.elevation = ""
        self.latitude = ""
        self.longitude = ""
        self.name = ""
        self.description = ""
        self.category = ""
    }

    
    init(name: String, latitude: String, longitude: String, elevation: String, address_title: String, address_street: String, description: String, category: String) {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.address_title = address_title
        self.address_street = address_street
        self.description = description
        self.category = category
    }
    
    public init (jsonStr: String){
        self.name = ""
        self.latitude = ""
        self.longitude = ""
        self.elevation = ""
        self.address_title = ""
        self.address_street = ""
        self.description = ""
        self.category = ""
        if let data: NSData = jsonStr.data(using: String.Encoding.utf8) as NSData?{
            do{
                let dict = try JSONSerialization.jsonObject(with: data as Data,options:.mutableContainers) as?[String:AnyObject]
                self.name = (dict!["name"] as? String)!
                self.description = (dict!["description"] as? String)!
                self.category = (dict!["category"] as? String)!
                self.address_title = (dict!["address-title"] as? String)!
                self.address_street = (dict!["address-street"] as? String)!
                self.elevation = (dict!["elevation"] as? String)!
                self.latitude = (dict!["latitude"] as? String)!
                self.longitude = (dict!["longitude"] as? String)!
                
                
            } catch {
                print("unable to convert Json to a dictionary")
                
            }
        }
    }
    
    public init(dict:[String:Any]){
        self.name = dict["name"] == nil ? "unknown" : dict["name"] as! String
        self.description = dict["description"] == nil ? "unknown" : dict["description"] as! String
        self.category = dict["category"] == nil ? "unknown" : dict["category"] as! String
        self.address_title = dict["address-title"] == nil ? "unknown" : dict["address-title"] as! String
        self.address_street = dict["address-street"] == nil ? "unknown" : dict["address-street"] as! String
        self.elevation = dict["elevation"] == nil ? "unknown" : dict["elevation"] as! String
        self.latitude = dict["latitude"] == nil ? "unknown" : dict["latitude"] as! String
        self.longitude = dict["longitude"] == nil ? "unknown" : dict["longitude"] as! String
    }
    
    public func toJsonString() -> String {
        var jsonStr = "";
        let dict:[String : Any] = ["name": name,"description": description,"category": category,"address-title": address_title,"address-street": address_street,"elevation": elevation,"latitude": latitude,"longitude": longitude] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print("unable to convert dictionary to a Json Object with error: \(error)")
        }
        return jsonStr
    }
    
    
}
