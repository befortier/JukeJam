//
//  User.swift
//  JukeJam
//
//  Created by Rena fortier on 12/26/18.
//  Copyright © 2018 Ben Fortier. All rights reserved.
//

import Foundation
import UIKit

class Location: NSObject, NSCoding{
    var city: String
    var city_id: UInt32
    var country: String
    var country_code: String
    var latitude: Float
    var longitude: Float
    var located_in: String
    var name: String
    var region: String
    var region_id: String
    var state: String
    var street: String
    var zip: String
    
    init(city: String, city_id: UInt32, country: String, country_code: String, latitude: Float, longitude: Float, located_in: String, name: String, region: String, region_id: String, state: String, street: String, zip: String) {
        self.city = city
        self.city_id = city_id
        self.country = country
        self.country_code = country_code
        self.latitude = latitude
        self.longitude = longitude
        self.located_in = located_in
        self.name = name
        self.region = region
        self.region_id = region_id
        self.state = state
        self.street = street
        self.zip = zip
    }
    required init?(coder aDecoder: NSCoder) {
        self.city = (aDecoder.decodeObject(forKey: "city") as? String)!
        self.city_id = (aDecoder.decodeObject(forKey: "city_id") as? UInt32)!
        self.country = (aDecoder.decodeObject(forKey: "country") as? String)!
        self.country_code = (aDecoder.decodeObject(forKey: "country_code") as? String)!
        self.latitude = (aDecoder.decodeFloat(forKey: "latitude") as? Float)!
        self.longitude = (aDecoder.decodeFloat(forKey: "longitude") as? Float)!
        self.located_in = (aDecoder.decodeObject(forKey: "located_in") as? String)!
        self.name = (aDecoder.decodeObject(forKey: "name") as? String)!
        self.region = (aDecoder.decodeObject(forKey: "region") as? String)!
        self.region_id = (aDecoder.decodeObject(forKey: "region_id") as? String)!
        self.state = (aDecoder.decodeObject(forKey: "state") as? String)!
        self.street = (aDecoder.decodeObject(forKey: "street") as? String)!
        self.zip = (aDecoder.decodeObject(forKey: "zip") as? String)!

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "city")
        aCoder.encode(city_id, forKey: "city_id")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(country_code, forKey: "country_code")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(located_in, forKey: "located_in")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(region, forKey: "region")
        aCoder.encode(region_id, forKey: "region_id")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(street, forKey: "street")
        aCoder.encode(zip, forKey: "zip")
    }
    
}
class User: NSObject, NSCoding{
    var first_name: String?
    var last_name: String?
    var address: Location?
    var birthday: String?
    var email: String?
    var gender: String?
    var name: String
    var location: String?
    var F_id: String?
    var G_id: String?
    var username: String?

    init(name: String){
        self.name = name
    }

    required init?(coder aDecoder: NSCoder) {

        self.name = (aDecoder.decodeObject(forKey: "name") as? String)!
        self.first_name = (aDecoder.decodeObject(forKey: "first_name") as? String)!
        self.last_name = (aDecoder.decodeObject(forKey: "last_name") as? String)!
        self.birthday = (aDecoder.decodeObject(forKey: "birthday") as? String)!
        self.gender = (aDecoder.decodeObject(forKey: "gender") as? String)!
        self.email = (aDecoder.decodeObject(forKey: "email") as? String)!
        self.gender = (aDecoder.decodeObject(forKey: "gender") as? String)!
        self.location = (aDecoder.decodeObject(forKey: "location") as? String)!
//        self.address = (aDecoder.decodeObject(forKey: "address") as? Location)!
        self.F_id = (aDecoder.decodeObject(forKey: "F_id") as? String)!
        self.G_id = (aDecoder.decodeObject(forKey: "G_id") as? String)!
        self.username = (aDecoder.decodeObject(forKey: "username") as? String)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(email, forKey: "email")
//        aCoder.encode(address, forKey: "address")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(G_id, forKey: "G_id")
        aCoder.encode(F_id, forKey: "F_id")
        aCoder.encode(username, forKey: "username")
    }

    
    
}

extension UIViewController {
    func loadInfo() -> User{
        
        let def = UserDefaults.standard
        var curUser: User?
        let userData = def.object(forKey: "user") as? NSData
        if let user = userData {
            curUser = (NSKeyedUnarchiver.unarchiveObject(with: user as Data) as? User)!
        }
        return curUser!
    }
}

extension UIColor {

    func petal() -> UIColor{
        return UIColor(red:0.98, green:0.53, blue:0.40, alpha:1.0)
    }
    
    func poppy() -> UIColor{
        return UIColor(red:1.00, green:0.26, blue:0.05, alpha:1.0)
    }
    
    func stem() -> UIColor{
        return UIColor(red:0.50, green:0.74, blue:0.62, alpha:1.0)
    }
    
    func springGreen() -> UIColor{
        return UIColor(red:0.54, green:0.85, blue:0.35, alpha:1.0)
    }
    
}
