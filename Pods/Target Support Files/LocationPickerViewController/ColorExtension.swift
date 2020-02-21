//
//  ColorExtension.swift
//  KAS4Elderly
//
//  Created by Moritz Schaub on 21.02.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import MapKit

@available(iOS 13.0, *)
extension Color {

    func uiColor() -> UIColor {

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

func lookLocation( _ location: CLLocation) -> String? {
        let geocoder = CLGeocoder()
    var retVal: String? = nil
    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if error == nil{
            let firstLocation = placemarks![0]
            retVal = firstLocation.name
        } else{
            print(error!)
        }
    }
    return retVal
}
