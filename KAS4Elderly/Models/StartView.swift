//
//  StartView.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 02.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI



struct StartView: View {
	
	
	//@Environment(\.sizeCategory) var sizeCategory
	@ObservedObject var userData: UserData
	
	
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color.red, Color.white]), startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
			
			VStack{
				Text("Wilkommen" + "\n" + "bei Skills")
					.multilineTextAlignment(.center)
					.font(.largeTitle)
					.foregroundColor(.white)
				
				Spacer()
				
				Button(action: {
					self.userData.showLoginView = true
				}) {
					Text("Einloggen")
						.padding()
						.background(Color.red)
						.foregroundColor(.white)
						.clipShape(Capsule())
						.padding()
				}
				.sheet(isPresented: self.$userData.showLoginView){
					LoginView(userData: self.userData)
				}
				
				Button(action: {
					self.userData.showRegisterView = true
				}) {
					Text("Registrieren")
						.padding()
						.background(Color.red)
						.foregroundColor(.white)
						.clipShape(Capsule())
						.padding()
				}
				.sheet(isPresented: self.$userData.showRegisterView){
					RegisterView(userData: self.userData)
				}
				Spacer()
				
			}
		}
	}
}

struct StartView_Previews: PreviewProvider {
	static var previews: some View {
		StartView(userData: UserData()).navigationBarHidden(true)
	}
}
