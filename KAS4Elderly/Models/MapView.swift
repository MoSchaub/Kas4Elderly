//
//  MapView.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 23.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @ObservedObject var userData : UserData
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: SkillAnnotation?
    @Binding var showingPlaceDetails: Bool
    var annotations: [SkillAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        return mapView
    }
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if annotations.count != view.annotations.count{
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
        
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //No Placemark found to recycle make a new one!
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else{
                //Found a Placemark to recycle use the old one
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //guard let placemark = view.annotation as? MKPointAnnotation else { return }
            guard let skill = parent.userData.skill(at: view.annotation!.coordinate) else { return }
            let skillPlacemark = SkillAnnotation(annotation: view.annotation!, skill: skill)
            parent.selectedPlace = skillPlacemark
            parent.showingPlaceDetails = true
        }
        
    }
    
}

extension SkillAnnotation {
    static var example: SkillAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return SkillAnnotation(annotation: annotation, skill: Skill.example)
    }
}

struct MapView_Previews: PreviewProvider {
    static var annotations: [SkillAnnotation]{
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 50.9317, longitude: 6.9582)
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        return [SkillAnnotation(annotation: annotation, skill: Skill.example), SkillAnnotation.example]
    }
    
    static var previews: some View {
        MapView(userData: UserData(), centerCoordinate: .constant(CLLocationCoordinate2D(latitude: 50.9317, longitude: 6.9582)), selectedPlace: .constant(SkillAnnotation.example), showingPlaceDetails: .constant(false),annotations:
            MapView_Previews.annotations)
    }
}
