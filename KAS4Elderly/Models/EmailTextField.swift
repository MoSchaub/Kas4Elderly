//
//  EmailTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 01.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct EmailTextField: View {
    
    @ObservedObject var userData : UserData
    
    var body: some View {
        VStack {
            
            TextField("E-mail eingeben", text: $userData.localUser.email, onCommit: {
                self.userData.weiter()
            }).modifier(TextFieldModifier())
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
            
            TextField(" Email erneut eingeben", text: self.$userData.secondEm, onCommit: {
                self.userData.weiter()
            })
                .modifier(TextFieldModifier())
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
            
            Spacer()
            
            Text(userData.errorMessage)
                .foregroundColor(.red)
            .animation(.default)
                .padding()
            
        }
    }
    
}

struct EmailTextField_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextField(userData: UserData())
    }
}
