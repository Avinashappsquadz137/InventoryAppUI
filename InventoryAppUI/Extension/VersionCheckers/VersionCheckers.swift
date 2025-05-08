//
//  VersionCheckers.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 07/05/25.
//

import Foundation

class VersionChecker: ObservableObject {
    @Published var shouldForceUpdate = false
    let appID = "6742139625"

    func checkForUpdate() {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String,
                  let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            else {
                return
            }

            print("📱 Current: \(currentVersion) | 🛒 App Store: \(appStoreVersion)")
            if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                DispatchQueue.main.async {
                    self.shouldForceUpdate = true
                }
            }
        }.resume()
    }
}
