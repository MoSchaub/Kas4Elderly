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
	
	enum Category : String{
		
		case food = "Ernährung"
		case fitness = "Fitness"
		case media = "Medien"
		case mentalFitness = "mentale Fitness"
		
		case other = "sonstiges"
		
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
	
	init(_ pfObject: PFObject) {
		self.category = Category.cat(for: pfObject["type"] as! String)
		self.id = pfObject.objectId!
		self.name = pfObject["name"] as! String
		self.maximumPeople = pfObject["max"] as! Int
		self.minimumPeople = pfObject["min"] as! Int
		self.location = CLLocationCoordinate2D(latitude: pfObject["latitude"] as! Double, longitude: pfObject["longitude"] as! Double)
		self.owner = User(PFUser.current()!)
		self.address = pfObject["address"] as! String
	}
	
	init(name: String, maximumPeople: Int, minimumPeople: Int, location: CLLocationCoordinate2D, category: Category, user: User, address: String) {
		self.id = UUID().uuidString
		self.name = name
		self.maximumPeople = maximumPeople
		self.minimumPeople = minimumPeople
		self.location = location
		self.category = category
		self.owner = user
		self.address = ""
	}
	
	static func == (lhs: Skill, rhs: Skill) -> Bool {
		lhs.id == rhs.id
	}

}

extension Skill.Category: Identifiable{
	var id: String { rawValue }
}
