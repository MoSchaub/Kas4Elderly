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
		case mentalFitness
		
		case other
		
		static var all = [Category.food,.fitness,.media,.mentalFitness,.other]
	}
	
	 
	
	var name: String
	
	var maximumPeople: Int
	
	var minimumPeople: Int
	
	var location: CLLocationCoordinate2D
	
	var category: Category
}

