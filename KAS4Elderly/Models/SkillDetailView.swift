//
//  SkillDetailView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 23.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct SkillDetailView: View {
    
    @State private var editingMode = false
    @State private var editNumber = 0
    @State private var showShareSheet = false
    let owned: Bool
    
    @State var image = Image("user")
    @ObservedObject var userData: UserData
    
    @State var skill: Skill
    
    var skillIndex: Int? {
        userData.localSkills.firstIndex(where: { $0 == skill})
    }
    
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("name")) {
                    HStack {
                        Text(skill.name)
                        if self.owned{
                            Spacer()
                            
                            Button(action: {
                                self.editingMode = true
                                self.editNumber = 1
                            }) {
                                Image(systemName: "pencil.circle")
                            }.padding()
                            .sheet(isPresented: $editingMode, onDismiss: {
                                self.userData.update(skill: self.skill)
                                self.loadImage()
                                if let skillIndex = self.skillIndex{
                                    self.skill = self.userData.localSkills[skillIndex]
                                }
                            }, content: {
                                SkillEditSheet(userData: self.userData, skill: self.$skill, number: self.editNumber)
                            })
                        }
                    }
                }
                
                HStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.primary, lineWidth: 1))
                        .shadow(color: .primary, radius: 2)
                        .padding()
                        .animation(.default)
                    if self.owned{
                        Spacer()
                        
                        Button(action: {
                            self.editingMode = true
                            self.editNumber = 2
                        }) {
                            Image(systemName: "pencil.circle")
                        }.padding()
                    }
                }
                
                
                
                Section(header: Text("Kategorie")) {
                    HStack {
                        Text(skill.category.rawValue)
                        if self.owned{
                            Spacer()
                            
                            Button(action: {
                                self.editingMode = true
                                self.editNumber = 3
                            }) {
                                Image(systemName: "pencil.circle")
                            }.padding()
                        }
                    }
                }
                
                Section(header: Text("Kontakt")){
                    Text(skill.owner.email)
                }
                
                Section(header: Text("Anzahl Teilnehmer")){
                    HStack {
                        VStack{
                            Text("Minimal: \(skill.minimumPeople)")
                            
                            Text("Maximal: \(skill.maximumPeople)")
                        }
                        if self.owned{
                            Spacer()
                            
                            Button(action: {
                                self.editingMode = true
                                self.editNumber = 4
                            }) {
                                Image(systemName: "pencil.circle")
                            }.padding()
                        }
                    }
                }
                
                Section(header: Text("Ort")){
                    HStack {
                        Text("Ort: \(skill.address) (\(skill.location.latitude); \(skill.location.longitude))")
                            .onLongPressGesture {
                                //show share sheet
                                self.showShareSheet = true
                        }
                        if self.owned{
                            Spacer()
                            
                            Button(action: {
                                self.editingMode = true
                                self.editNumber = 5
                            }) {
                                Image(systemName: "pencil.circle")
                            }.padding()
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(skill.name), displayMode: .inline)
        .sheet(isPresented: self.$showShareSheet) {
            ShareSheet(activityItems: ["\(self.skill.location)"])
        }
        .onAppear {
            if let skillIndex = self.skillIndex{
                self.skill = self.userData.localSkills[skillIndex]
            }
            self.loadImage()
        }
    }
    func loadImage() {
        if let inputImage = skill.image {
            self.image = Image(uiImage: inputImage)
        } else {
            image = Image(uiImage: UIImage(named: "user")!)
        }
    }
}

struct SkillDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SkillDetailView(owned: false, image: Image(uiImage: UIImage(data: Data(base64Encoded: defaultImage)! )!), userData: UserData(), skill: Skill.example)
    }
}

extension CLLocationCoordinate2D: CustomDebugStringConvertible{
    public var debugDescription: String {
        "(\(self.latitude), \(self.longitude)"
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
      
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
      
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
