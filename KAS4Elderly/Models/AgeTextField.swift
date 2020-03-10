//
//  AgeTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 31.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct AgeTextField: View {
	@Binding var age: String
	
	var body: some View {
		VStack {
			TextField(" Alter eingeben", text: $age)
				.keyboardType(.numbersAndPunctuation)
				.modifier(TextFieldModifier())
		}
	}
	
}

struct AgeTextField_Previews: PreviewProvider {
	static var previews: some View {
		AgeTextField(age: .constant(""))
	}
}
