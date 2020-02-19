//
//  Skill.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 24.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import Foundation
import MapKit

struct Skill{
	enum Category : String{
		case food
		case fitness
		case media
		
		static var all = [Category.food,.fitness,.media]
	}
	
	 
	
	var name: String
	
	var organizer: User
	
	var maximumPeople: Int
	
	var minimumPeople: Int
	
	var location: CLLocationCoordinate2D
	
	var category: Category
}

