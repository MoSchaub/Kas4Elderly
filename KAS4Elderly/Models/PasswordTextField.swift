//
//  PasswordTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 31.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct PasswordTextField: View{
    
    @Binding var password: String
    @Binding var secondPassword: String
    
    var body: some View {
        VStack {
            SecureField("Passwort eingeben", text: $password)
                .modifier(TextFieldModifier())
                //.textContentType(.newPassword)
            
            SecureField("Passwort erneut eingeben", text: $secondPassword)
                .modifier(TextFieldModifier())
                //.textContentType(.newPassword)
        }
    }
    
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(password: .constant(""),secondPassword: .constant(""))
    }
}
