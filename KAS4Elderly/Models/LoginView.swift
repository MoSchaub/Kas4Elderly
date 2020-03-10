//
//  LoginView.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 02.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct LoginView: View {
	
	@Environment(\.presentationMode) var presentationMode
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
				
				TextField("Name",text: $username, onCommit: login)
					.modifier(TextFieldModifier())
					.textContentType(.username)
				SecureField("Passwort", text: $password, onCommit: login)
					.modifier(TextFieldModifier())
					.textContentType(.password)
				
				
				Button(action: {
					self.login()
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
					self.presentationMode.wrappedValue.dismiss()
					self.userData.errorMessage = ""
				}) {
					Text("zurück")
				} .padding()
			}
			
		}
	}
	
	func login(){
		self.userData.login(name: username, password: password)
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
