//
//  PasswordTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 31.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct PasswordTextField: View {
    
    @ObservedObject var userData: UserData
    
    
    var body: some View {
        VStack {
            SecureField("Passwort eingeben", text: $userData.localUser.password, onCommit: {
                self.userData.weiter()
            })
                .modifier(TextFieldModifier())
            
            SecureField("Passwort erneut eingeben", text: self.$userData.secondPW, onCommit: {
                 self.userData.weiter()
             })
                .modifier(TextFieldModifier())
            
            Spacer()
            
            Text(userData.errorMessage)
                .foregroundColor(.red)
            .animation(.default)
            
        }
    }
    
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(userData: UserData())
    }
}
