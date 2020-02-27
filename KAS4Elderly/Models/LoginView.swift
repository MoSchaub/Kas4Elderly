//
//  LoginView.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 02.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	
	@ObservedObject var userData : UserData
	@State private var username = UserDefaults.standard.string(forKey: "username") ?? ""
	@State private var password = UserDefaults.standard.string(forKey: "password") ?? ""
	
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color.red, Color.white]), startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
			
			VStack{
				Text("Einloggen")
					.font(.largeTitle)
					.fontWeight(.black)
				
				Spacer()
				
				TextField("Name",text: $username)
					.modifier(TextFieldModifier())
					.textContentType(.username)
				SecureField("Passwort", text: $password)
					.modifier(TextFieldModifier())
					.textContentType(.password)
				
				
				Button(action: {
					self.userData.login(name: self.username, password: self.password)
				}) {
					Text("Einloggen")
						.padding()
						.background(Color.red)
						.foregroundColor(.white)
						.clipShape(Capsule())
						.padding()
				}
				
				Text(userData.errorMessage)
					.foregroundColor(.red)
					.animation(.default)
				
				Spacer()
				
				Button(action: {
					self.userData.showLoginView = false
					self.userData.errorMessage = ""
				}) {
					Text("zurück")
				} .padding()
			}
			
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			LoginView(userData: UserData())
				.navigationBarTitle("")
				.navigationBarHidden(true)
		}
	}
}
