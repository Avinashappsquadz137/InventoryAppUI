//
//  MoreOrderCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MoreOrderCell: View {
    let clientName: String
    let clientContact: String
    let clientLocation: String
    let clientDate: String
    let source: String
    var openDetails: () -> Void
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Client Name : \(clientName)")
                    .font(.headline)
                Text("Phone Number : \(clientContact)")
                    .font(.headline)
                Text("Location : \(clientLocation)")
                    .font(.headline)
                Text("Show Date : \(clientDate)")
                    .font(.headline)
            }
            Spacer()
            HStack {
                if source == "SubmitChallanView" {
                    VStack{
                        Spacer()
                        Button(action: openDetails) {
                            Text("OPEN PDF")
                                .font(.callout)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            guard let currentLocation = locationManager.currentLocation else {
                                print("Current location not available.")
                                return
                            }
                            navigateToGoogleMaps(address: clientLocation, currentLocation: currentLocation)
                            
                        }){
                            Image(systemName: "mappin.and.ellipse.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }else {
                    Button(action: openDetails) {
                        
                        Text("OPEN")
                            .font(.callout)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(5)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    func navigateToGoogleMaps(address: String, currentLocation: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first,
                  let destinationLocation = placemark.location else {
                print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let destinationLatitude = destinationLocation.coordinate.latitude
            let destinationLongitude = destinationLocation.coordinate.longitude
            
            let startLatitude = currentLocation.coordinate.latitude
            let startLongitude = currentLocation.coordinate.longitude
            
            // Google Maps URL scheme
            let googleMapsURL = "comgooglemaps://?daddr=\(destinationLatitude),\(destinationLongitude)&saddr=\(startLatitude),\(startLongitude)&directionsmode=driving"
            
            if let url = URL(string: googleMapsURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Google Maps app is not installed. Opening in browser.")
                let browserURL = "https://www.google.com/maps/dir/?api=1&destination=\(destinationLatitude),\(destinationLongitude)&origin=\(startLatitude),\(startLongitude)&travelmode=driving"
                if let url = URL(string: browserURL) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        private let locationManager = CLLocationManager()
        @Published var currentLocation: CLLocation?
        
        override init() {
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                currentLocation = location
                locationManager.stopUpdatingLocation() // Stop updates to conserve battery
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    }
    
}
