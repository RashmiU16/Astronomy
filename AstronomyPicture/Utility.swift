//
//  Utility.swift
//  AstronomyPicture
//
//  Created by Rashmi uppin on 6/21/21.
//

import Foundation
import UIKit
import SystemConfiguration
class Utility: NSObject {
    
    class
        func AlertController(title:String,message:String,view:UIViewController) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    class func isConnectedToNetwork() -> Bool {
        
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        guard let routeReachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(routeReachability, &flags) {
            return false
        }
        
        let rechable = flags.contains(.reachable)
        let needsConnect = flags.contains(.connectionRequired)
        
        return (rechable && !needsConnect)
    }
    
}
struct astronomyPictureDetails:Codable {
    var coptRight:String?
    var date:String?
    var explanation:String?
    var hdurl:String?
    var media_type:String?
    var service_version:String?
    var title:String?
    var url:String?
    var imageData:Data?
}
