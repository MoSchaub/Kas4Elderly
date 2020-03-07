//
//  UserData.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 25.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import MapKit
import Parse
import SwiftUI

class UserData: ObservableObject {
	
	@Published var localUserSkills: [Skill]
	@Published var localSkills: [Skill]
	
	private var user: User?{
		User(self.currUser()!)
	}
	
	@Published var localUser = User(name: "", password: "", email: "", age: "", location: CLLocationCoordinate2D(latitude: 20, longitude: 20), imageString: "")
	
	@Published var secondPW = ""
	@Published var secondEm = ""
	
	@Published var loggedIn = false
	
	@Published var username = UserDefaults.standard.string(forKey: "username")
		
	@Published var password = UserDefaults.standard.string(forKey: "password")
	
	
	//profileView
	@Published var editing = false
	@Published var editNumber = 0
	
	@Published var showLoginView = false
	
	//register View
	@Published var showRegisterView = false
	@Published var currentProperty = 0
	@Published var errorMessage = ""
	
	func editTextField(with number: Int) -> some View{
		currentProperty = number
		return Group{
			if number == 0 {
				NameTextField(userData: self)
			} else if number == 2 {
				AgeTextField(userData: self)
			} else if number == 3{
				EmailTextField(userData: self)
			} else if number == 4 {
				LocationView(userData: self)
			} else {
				Text("Something went wrong")
			}
		}
	}
	
	init() {
		self.localUserSkills = [Skill]()
		self.localSkills = [Skill]()
		self.updateSkills()
		if UserDefaults.standard.bool(forKey: "loggedIn"){
			self.login(name: username!, password: password!)
		}
	}
	
	//MARK: Register functions
	
	func weiter() {
		if editing{
			if validate(number: editNumber){
				errorMessage = ""
				self.updateUser()
			}
		}else{
			if validate(number: currentProperty){
				errorMessage = ""
				if currentProperty < 4 {
					currentProperty += 1
				} else if currentProperty == 4{
					self.createUser()
				}
			}
		}
	}
	
	func property(for number: Int) -> Any?{
		switch number {
		case 0:
			return localUser.name
		case 1:
			return localUser.password
		case 2:
			return localUser.age
		case 3:
			return localUser.email
		case 4:
			return localUser.location
		default:
			return nil
		}
	}
	
	func validate(number: Int) ->Bool{
		if number < 4{
			let property = self.property(for: number) as! String
			
			if number != 2{
				if property == "" {
					errorMessage = "Bitte etwas eingeben"
					return false
				}
				
				if number == 1{ //password validation
					if localUser.password != self.secondPW{
						errorMessage = "Beide Male muss das selbe Passwort eingegeben werden"
						return false
					} else if !isValidPassword(localUser.password){
						errorMessage = "Bitte ein sicheres Passwort mit Buchstaben, Zahlen und mindestens 8 Zeichen eingeben"
						return false
					} else{
						return true
					}
				} else if number == 3{ //email validation
					if localUser.email != self.secondEm{
						errorMessage = "Beide Male muss die selbe E-mail eingegeben werden"
						return false
					} else if !isValidEmail(localUser.email){
						errorMessage = "Bitte eine E-mail Adresse eingeben"
						return false
					} else{
						return true
					}
				} else if number == 0{
					return true
				}
			} else{
				if Int(property) != nil{
					return true
				} else{
					errorMessage = "Bitte Zahlen eingeben"
					return false
				}
			}
		} else if number == 4{ //location
			return true
		} else{
			return false
		}
		return false
	}
	
	func isValidPassword(_ password: String) -> Bool {
		let passwordRegex = "^(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
		
		let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
		return passwordPred.evaluate(with: password)
	}
	
	func isValidEmail(_ email: String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	func zurück(){
		if self.currentProperty > 0 {
			self.currentProperty += -1
			self.errorMessage = ""
		} //else{
//			self.showRegisterView = false
//			self.errorMessage = ""
//			self.currentProperty = 0
//		}
	}
	
	//MARK: Skill functions
	
	func updateSkills() {

		let query = PFQuery(className:"Skill")
		query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
			if let error = error {
				// Log details of the failure
				print(error.localizedDescription)
			} else if let objects = objects {
				// The find succeeded.
				print("Successfully retrieved \(objects.count) scores.")
				// Do something with the found objects
				var results = [Skill]()
				for object in objects {
					results.append(Skill(object))
				}
				self.localSkills = results
			}
		}

	}
	
	func allLocations() -> [SkillAnnotation] {
		updateSkills()
		updateSkills()
		var annotations = [SkillAnnotation]()
		for skill in localSkills {
			annotations.append(skill.annotation())
		}
		return annotations
	}
	
	func skill(at location:CLLocationCoordinate2D) -> Skill?{
		self.updateSkills()
		if let skill = localSkills.first(where: {$0.location == location}){
			return skill
		} else {
			return nil
		}
	}
	
	func deleteSkills(at offsets: IndexSet){
		
		//for every index in indexSet
		for index in offsets{
			
			//get the skill
			let skill = localUserSkills[index]
			let query = PFQuery(className: "Skill")
			
			query.getObjectInBackground(withId: skill.id) { (parseObject, error) in
				if error != nil {
					print(error!)
					self.errorMessage = error!.localizedDescription
				} else if let parseObject = parseObject {
					//if it exists delete it from Cloud Database
					parseObject.deleteInBackground { (succeded, error) in
						if let error = error{
							return
								self.errorMessage = error.localizedDescription
						} else{
							//update local stroge
							self.localUserSkills.remove(at: index)
							self.updateUserSkills()
							self.errorMessage = "gelöscht"
						}
					}
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
				self.errorMessage = ""
			}
		}
	}
	
	private func updateUserSkills(){
		if currUser() != nil{
			let query = PFQuery(className:"Skill")
			query.whereKey("owner", equalTo: currUser() as Any)
			query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
				if let error = error {
					// Log details of the failure
					print(error.localizedDescription)
				} else if let objects = objects {
					// The find succeeded.
					print("Successfully retrieved \(objects.count) scores.")
					// Do something with the found objects
					var results = [Skill]()
					for object in objects {
						results.append(Skill(object))
					}
					if results.count > 0{
						var filteredResults = [Skill]()
						while !results.isEmpty {
							
							let akt = results.removeFirst()
							if akt.owner.name == self.currUser()!.username! {
								filteredResults.append(akt)
							}
						}
						self.localUserSkills = filteredResults
						return
					}
					self.localUserSkills = results
				}
			}
		}
	}
	
	func add(skill: Skill){
		let parseObject = PFObject(className:"Skill")
		self.updateAddress(for: skill)
		
		parseObject["name"] = skill.name
		parseObject["max"] = skill.maximumPeople
		parseObject["min"] = skill.minimumPeople
		parseObject["longitude"] = skill.location.longitude
		parseObject["latitude"] = skill.location.latitude
		parseObject["type"] = skill.category.rawValue
		parseObject["owner"] = PFUser.current()!
		parseObject["address"] = skill.address
		
		// Saves the new object.
		parseObject.saveInBackground {
			(success: Bool, error: Error?) in
			if (success) {
				// The object has been saved.
				self.errorMessage = "gespeichert"
				self.updateUserSkills()
			} else {
				// There was a problem, check error.description
				self.errorMessage = error!.localizedDescription
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				self.errorMessage = ""
			}
		}
	}
	
	//MARK: User functions
	
	private func currUser() -> PFUser?{
		if let currentUser = PFUser.current() {
			return currentUser
		} else {
			return nil
		}
	}

	func createUser() {
		let user = PFUser()
		user.username = localUser.name
		user.password = localUser.password
		user.email =
			localUser.email
		user["age"] = localUser.age
		user["imageString"] = localUser.imageString
		user["longitude"] = localUser.location.longitude
		user["latitude"] = localUser.location.latitude
		
		user.signUpInBackground( block: { succeeded, error in
			if let error = error {
				print(error.localizedDescription)
				self.errorMessage = error.localizedDescription
				// Show the errorString somewhere and let the user try again.
			} else {
				print("signed up")
				self.errorMessage = "Registriert"
				// Hooray! Let them use the app now.
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				self.errorMessage = ""
			}
		})
	}
	
	func login(name: String, password: String){
		PFUser.logInWithUsername(inBackground: name, password: password, block: { user, error in
			if user != nil {
				// Do stuff after successful login.
				self.username = name
				self.password = password
				self.loggedIn = true
				UserDefaults.standard.set(true, forKey: "loggedIn")
				self.setupAfterLogin()
				UserDefaults.standard.synchronize()
			} else {
				// The login failed. Check error to see why.
				print(error!.localizedDescription)
				self.errorMessage = error!.localizedDescription
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
					self.errorMessage = ""
				}
			}
		})
		
	}
	
	func setupAfterLogin(){
		self.localUser = user!
		self.updateUserSkills()
		UserDefaults.standard.set(self.username, forKey: "username")
		UserDefaults.standard.set(self.password, forKey: "password")
	}
	
	func logOut(){
		self.errorMessage = ""
		self.loggedIn = false
		UserDefaults.standard.set(false, forKey: "loggedIn")
		UserDefaults.standard.set("",forKey: "username")
		UserDefaults.standard.set("",forKey: "password")
		UserDefaults.standard.synchronize()
	}
	
	func update(skill: Skill){
		let query = PFQuery(className:"Skill")
		
		query.getObjectInBackground(withId: skill.id) { (parseObject, error) in
			if error != nil {
				print(error!)
			} else if let parseObject = parseObject {
				parseObject["name"] = skill.name
				parseObject["min"] = skill.maximumPeople
				parseObject["max"] = skill.minimumPeople
				parseObject["longitude"] = skill.location.longitude
				parseObject["latitude"] = skill.location.latitude
				parseObject["type"] = skill.category.rawValue
				parseObject.objectId = skill.id
				
				parseObject.saveInBackground()
				self.updateUserSkills()
			}
		}
	}
	
	func updateUser(){
		let currentUser = PFUser.current()
		if currentUser != nil {
			currentUser!.email = localUser.email
			currentUser!["age"] = localUser.age
			currentUser!["imageString"] = localUser.imageString
			currentUser!["longitude"] = localUser.location.longitude
			currentUser!["latitude"] = localUser.location.latitude
			
			currentUser?.saveInBackground(block: { (succeeded, error) in
				if error != nil{
					// There was a problem, check error.description
					print(error!.localizedDescription)
					self.errorMessage = error!.localizedDescription
				} else{
					// The PFUser has been saved.
					self.errorMessage = "geändert"
					self.editing = false
					DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
						self.errorMessage = ""
					}
				}
			})
		}
		
	}
	
	
	
	func deleteUser() {
		let currentUser = PFUser.current()
		if currentUser != nil {
			// Deletes the user.
			currentUser!.deleteInBackground()
			errorMessage = "account gelöscht"
		} else{
			errorMessage = "ein Fehler ist aufgetreten versuche es später erneut"
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
			self.errorMessage = ""
		}
		
	}
	
	func resetPassword(for email: String) {
		if currUser() != nil{
			PFUser.requestPasswordResetForEmail(inBackground: currUser()!.email!)
			errorMessage = "reset angefordert"
		} else{
			errorMessage = "versuche es später noch einmal"
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
			self.errorMessage = ""
		}
	}
	
	
	// o)l*3nfJgsmUoFkJWa&C

	func updateAddress(for skill: Skill){
		var skill = skill
		
		let geocoder = CLGeocoder()
		
		let location = CLLocation(latitude: skill.location.latitude, longitude: skill.location.longitude)
		
		geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
			if let _ = error{ return }
			
			guard let placemarks = placemarks?.first else{ return}
			
			let streetNumber = placemarks.subThoroughfare ?? ""
			let streetName = placemarks.thoroughfare ?? ""
			
			
			skill.address = placemarks.areasOfInterest?.first ?? "\(streetName) \(streetNumber)"
		}
	}
	
}

extension CLLocationCoordinate2D : Equatable {
	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
}
