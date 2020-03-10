//
//  EmailTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 01.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct EmailTextField: View {
    
    @Binding var email: String
    @Binding var secondEmail: String
    
    var body: some View {
        VStack {
            
            TextField("E-mail eingeben", text: $email)
                .modifier(TextFieldModifier())
                .keyboardType(.emailAddress)
                //.textContentType(.emailAddress)
            
            TextField(" Email erneut eingeben", text: $secondEmail)
                .modifier(TextFieldModifier())
                .keyboardType(.emailAddress)
                //.textContentType(.emailAddress)
            
        }
    }
    
}

struct EmailTextField_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextField(email: .constant(""),secondEmail: .constant(""))
    }
}
