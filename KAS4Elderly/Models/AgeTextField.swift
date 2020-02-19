//
//  AgeTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 31.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct AgeTextField: View {
	
	@ObservedObject var userData: UserData
	
	var body: some View {
		VStack {
			TextField(" Alter eingeben", text: $userData.localUser.age, onCommit: {
				self.userData.weiter()
			})
				.keyboardType(.numbersAndPunctuation)
				.modifier(TextFieldModifier())
			
			Spacer()
			
			Text(userData.errorMessage)
				.foregroundColor(.red)
				.animation(.default)
			
		}
	}
	
}

struct AgeTextField_Previews: PreviewProvider {
	static var previews: some View {
		AgeTextField(userData: UserData())
	}
}
