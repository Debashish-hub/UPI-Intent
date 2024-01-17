//
//  UPIAppListViewModel.swift
//  UPI
//
//  Created by Debashish on 16/01/24.
//

import Foundation
import UIKit
struct UPIAppListViewModel: Decodable {
    var installedAppList: [UPIAppListViewDataModel] = []
    var upiApps: [String] = []
    var upiImageUrl: [URL] = []
    
    init() {
        checkUPIInstalledAppsInDevice()
    }
    
    mutating func checkUPIInstalledAppsInDevice() {
        var resourceFileDictionary: NSDictionary?
           
           //Load content of Info.plist into resourceFileDictionary dictionary
           if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
               resourceFileDictionary = NSDictionary(contentsOfFile: path)
           }
           
           if let resourceFileDictionaryContent = resourceFileDictionary {
               //Retrive the value from plist
               upiApps = resourceFileDictionaryContent.object(forKey: "LSApplicationQueriesSchemes")! as! [String]
           }
        
        let app = UIApplication.shared
        for i in upiApps {
            let appScheme = "\(i)://app"
            if app.canOpenURL(URL(string: appScheme)!) {
                installedAppList.append(createDataModel(appName: i))
            }
        }
    }
    
//    mutating func getIcons() {
//        for item in self.installedAppList {
//            let appName =  self.getAppName(itemName: item.appname).lowercased().replacingOccurrences(of: " ", with: "")
//            getAppIconURL(appName: appName) { url in
//                if let url = url {
//                    upiImageUrl.append(url)
//                }
//                print("\(item.appname) - \(url)")
//            }
//        }
//    }
    
    func getAppIconURL(appName: String) -> URL? {
        let url = URL(string: "https://itunes.apple.com/search?term=\(appName)&entity=software&country=IN")!
        var icon: URL? = nil
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
     
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]],
                   let iconURLString = results.first?["artworkUrl100"] as? String,
                   let iconURL = URL(string: iconURLString) {
                    icon = iconURL
                    return
                } else {
                    return
                }
            } catch {
                return
            }
        }.resume()
        return icon
    }
    
    func getAppName(itemName: String) -> String {
        if itemName.contains("paytm") {
            return "Paytm"
        } else if itemName.contains("phonepe") {
            return "PhonePe"
        } else if itemName.contains("gpay") {
            return "Google Pay"
        } else if itemName.contains("amazon") {
            return "Amazon"
        } else if itemName.contains("bhim") {
            return "Bhim"
        } else if itemName.contains("cred") {
            return "Cred"
        } else {
            return itemName.uppercased()
        }
    }
    
    func createDataModel(appName: String) -> UPIAppListViewDataModel {
        return UPIAppListViewDataModel(appname: appName)
    }
}
struct UPIAppListViewDataModel: Decodable,Hashable {
    var imageURL: UIImage? {
        return UIImage(named: appname)
    }
    var appname: String
    var appScheme: String {
        get {
            return "\(appname)://app"
        }
    }
 
}
