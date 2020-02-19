//
//  UserData.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 25.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import Foundation
import MapKit
import Parse
import Combine
import SwiftUI

class UserData: ObservableObject {
	
	@Published var skill = Skill(name: "", maximumPeople: 100, minimumPeople: 5, location: CLLocationCoordinate2D(latitude: 20, longitude: 20), category: .fitness)
	
	
	var showPopover = false
	
	var user: User?{
		self.currUser()
	}
	
	@Published var localUser = User(name: "", password: "", email: "", age: "", location: CLLocationCoordinate2D(latitude: 20, longitude: 20), imageString: "")
	
	@Published var secondPW = ""
	@Published var secondEm = ""
	
	@Published var loggedIn = false
	
	@Published var username = UserDefaults.standard.string(forKey: "username"){
		didSet{
			UserDefaults.standard.set(username, forKey: "username")
		}
	}
	@Published var password = UserDefaults.standard.string(forKey: "password"){
		didSet{
			UserDefaults.standard.set(password, forKey: "password")
		}
	}
	
	
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
		if UserDefaults.standard.bool(forKey: "loggedIn"){
			self.login(name: username!, password: password!)
			self.skill = Skill(name: "Skill", maximumPeople: 100, minimumPeople: 10, location: self.user!.location, category: .media)
		}
	}
	
	init(_ number: Int) {
		self.currentProperty = number
		self.skill = Skill(name: "Skill",  maximumPeople: 100, minimumPeople: 10, location: self.user!.location, category: .fitness)
	}
	
	
	
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
		} else{
			self.showRegisterView = false
			self.errorMessage = ""
			self.currentProperty = 0
		}
	}
	
	func currUser() -> User?{
		if let currentUser = PFUser.current() {
			return User(currentUser)
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
				// Hooray! Let them use the app now.
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
				self.showPopover = false
				UserDefaults.standard.set(true, forKey: "loggedIn")
				UserDefaults.standard.synchronize()
			} else {
				// The login failed. Check error to see why.
				print(error!.localizedDescription)
				self.errorMessage = error!.localizedDescription
			}
		})
		
	}
	
	func logOut(){
		self.errorMessage = ""
		self.loggedIn = false
		UserDefaults.standard.set(false, forKey: "loggedIn")
		UserDefaults.standard.synchronize()
		showPopover = true
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
						//reshuffling
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

	}
	
	func resetPassword(for email: String) {
		if currUser() != nil{
		PFUser.requestPasswordResetForEmail(inBackground: currUser()!.email)
			errorMessage = "reset angefordert"
		} else{
			errorMessage = "versuche es später noch einmal"
		}
	}
	
	
	// o)l*3nfJgsmUoFkJWa&C
	
}


