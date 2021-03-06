//
//  Skill.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 24.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import Foundation
import MapKit
import Parse

struct Skill: Identifiable, Equatable{
	
	enum Category : String, CustomStringConvertible{
		
		case food = "Ernährung"
		case fitness = "Fitness"
		case media = "Medien"
		case mentalFitness = "mentale Fitness"
		
		case other = "sonstiges"
		
		var description: String{
			self.rawValue
		}
		static var all = [Category.food,.fitness,.media,.mentalFitness,.other]
		
		static func cat(for string: String) -> Category{
			Category.all.first(where: {$0.rawValue == string}) ?? Category.all.last!
		}
	}
	
	var address: String
	
	var id : String
	
	var name: String
	
	var maximumPeople: Int
	
	var minimumPeople: Int
	
	var location: CLLocationCoordinate2D
	
	var category: Category
	
	var owner : User
	
	var imageString: String?
	
	var image: UIImage?{
        get{
            let data = Data(base64Encoded: imageString ?? defaultImage )
        return UIImage(data: data!)
        }
        set{
            if newValue == nil{
                imageString = UIImage(named: "user")!.base64(format: .PNG)
            }
            else {
                imageString = newValue!.base64(format: .PNG)
            }
        }
    }
	
	init(_ pfObject: PFObject) {
		self.category = Category.cat(for: pfObject["type"] as! String)
		self.id = pfObject.objectId!
		self.name = pfObject["name"] as! String
		self.maximumPeople = pfObject["max"] as! Int
		self.minimumPeople = pfObject["min"] as! Int
		self.location = CLLocationCoordinate2D(latitude: pfObject["latitude"] as! Double, longitude: pfObject["longitude"] as! Double)
		
		self.address = pfObject["address"] as! String
		self.imageString = pfObject["imageString"] as? String
		
		let ownerObject = pfObject["owner"] as! PFObject
		
		let query = PFUser.query()
		query?.whereKey("objectId", equalTo: ownerObject.objectId as Any)
        
		if let object =  try? query?.getFirstObject(){
			let pfUser = object as! PFUser
			self.owner = User(pfUser)
			owner.email = (pfObject["contact"] as? String)!
			return
		}
		self.owner = User.example
		
	}
	
	init(name: String, maximumPeople: Int, minimumPeople: Int, location: CLLocationCoordinate2D, category: Category, user: User, address: String, image: UIImage? = nil) {
		self.id = UUID().uuidString
		self.name = name
		self.maximumPeople = maximumPeople
		self.minimumPeople = minimumPeople
		self.location = location
		self.category = category
		self.owner = user
		self.address = ""
		self.image = image
	}
	
	static var example = Skill(name: "Skill", maximumPeople: 10, minimumPeople: 3, location: User.example.location , category: .other, user: User.example, address: "Examplestraße 1")
	
	static func == (lhs: Skill, rhs: Skill) -> Bool {
		lhs.id == rhs.id
	}
	
	func annotation() -> SkillAnnotation {
		
		let annotation = SkillAnnotation(coordinate: self.location, skill: self)
		annotation.title = name
		
		return annotation
	}

}

extension Skill.Category: Identifiable{
	var id: String { rawValue }
}
