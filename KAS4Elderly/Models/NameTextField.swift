//
//  NameTextField.swift
//  Teens4Elderly
//
//  Created by Moritz Schaub on 31.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct NameTextField: View {
    
    @ObservedObject var userData: UserData
    
    
    var body: some View {
        VStack {
            TextField("Name eingeben", text: $userData.localUser.name, onCommit:{
                self.userData.weiter()
            })
                .modifier(TextFieldModifier())
                .textContentType(.username)
            
            Spacer()
            
            Text(userData.errorMessage)
                .foregroundColor(.red)
            .animation(.default)
            
        }
    }
    
}

struct NameTextField_Previews: PreviewProvider {
    static var previews: some View {
        NameTextField( userData: UserData())
    }
}
