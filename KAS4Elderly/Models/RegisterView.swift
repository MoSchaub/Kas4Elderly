//
//  RegisterView.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 26.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct RegisterView: View {
	
	@ObservedObject var userData = UserData()
	@Environment(\.presentationMode) var presentationMode
	@State private var userProperties = ["Name", "Password","Alter","E-mail", "Wohnort"]
	@State private var currentProperty = 1
	@State private var user = User.example
	
	@State private var secondPassword = ""
	@State private var secondEmail = ""
	
	@State private var pinDown = false
	
	var body: some View {
		Group{
			ZStack {
				LinearGradient(gradient: Gradient(colors: [Color.red, Color.white]), startPoint: .top, endPoint: .bottom)
					.edgesIgnoringSafeArea(.all)
				
				
				VStack {
					if self.currentProperty == 1 {
						ScrollView {
							VStack{
								Text("Registrieren")
									.font(.largeTitle)
									.fontWeight(.black)
									.foregroundColor(.white)
								
								Spacer()
								
								NameTextField(name: $user.name)
								PasswordTextField(password: $user.password, secondPassword: $secondPassword)
								AgeTextField(age: $user.age)
								EmailTextField(email: $user.email, secondEmail: $secondEmail)
								
								Spacer()
							}
						}
						
					} else if self.userData.currentProperty == 1 {
						LocationPickerViewControllerWrapper(userData: userData, popUp: false, coordinate: $user.location, address: .constant(""))
						
					} else if currentProperty == 2{
						ImagePickerView( inputImage: $user.uiImage)
						
					} else{ //error
						Text("Etwas ist schiefgelaufen ")
						
					}
					
					
					Spacer()
					
					Text(userData.errorMessage)
						.foregroundColor(.red)
						.animation(.default)
					
					Button(action: {
						self.weiter()
					}) {
						Text("weiter")
						
					}.padding(.bottom)
					
					Button(action: {
						self.back()
					}) {
						Text("zurück")
					}.padding(.bottom)
					
					
				}
				
			}
		}
	}
	
	func weiter(){
		if validate(){
			if self.currentProperty < 2{
				currentProperty += 1
			} else{
				userData.localUser = user
				userData.createUser()
				self.presentationMode.wrappedValue.dismiss()
			}
		}
	}
	
	func back(){
		if currentProperty == 1{
			self.presentationMode.wrappedValue.dismiss()
		}
		else if currentProperty > 1{
			self.currentProperty += -1
		}
	}
	
	func validate() -> Bool{
		self.userData.validate(name: user.name, password: user.password, secondPassword: secondPassword, age: user.age, email: user.email, secondEmail: secondEmail, currentPoperty: currentProperty)
	}
	
	
}




struct TextFieldModifier: ViewModifier{
	func body(content: Content) -> some View {
		content
			.padding()
			.background(Color.secondary)
			.clipShape(RoundedRectangle(cornerRadius: 15))
			.padding()
			.disableAutocorrection(true)
			.autocapitalization(.none)
	}
	
}

struct RegisterView_Previews: PreviewProvider {
	
	static var previews: some View {
		RegisterView(userData: UserData())
	}
}
