//
//  RegisterView.swift
//  Teens4elderly
//
//  Created by Moritz Schaub on 26.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
	
	@ObservedObject var userData = UserData()
	
	@State private var userProperties = ["Name", "Password","Alter","E-mail", "Wohnort"]

	var body: some View {
		Group{
			ZStack {
				LinearGradient(gradient: Gradient(colors: [Color.red, Color.white]), startPoint: .top, endPoint: .bottom)
					.edgesIgnoringSafeArea(.all)
				
				if self.userData.currentProperty == 0 || self.userData.currentProperty == 1 || self.userData.currentProperty == 2 || self.userData.currentProperty == 3 {
						VStack {
							Text("Registrieren")
								.font(.largeTitle)
								.fontWeight(.black)
								.foregroundColor(.white)
							
							Spacer()
							
							if self.userData.currentProperty == 0{
								NameTextField(userData: userData)
							} else if self.userData.currentProperty == 1{
								PasswordTextField(userData: userData)
							}else if self.userData.currentProperty ==  2{
								AgeTextField(userData: userData)
							} else if self.userData.currentProperty == 3{
								EmailTextField(userData: userData)
							}
							
							Spacer()
							
							Button(action: {
								self.userData.weiter()
							}) {
								Text("weiter")
									
							}.padding(.bottom)
							
							Button(action: {
								self.userData.zurück()
							}) {
								Text("zurück")
							}.padding(.bottom)
							
						}
				} else if self.userData.currentProperty == 4 {
					LocationView(userData: userData)
					
				} else{ //error
					Text("Etwas ist schiefgelaufen ")
					
				}
			}
		}
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
