//
//  InternetConnectivity.swift
//  CinemaClub
//
//  Created by Ugowe on 10/26/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

let kREACHABILITYWITHWIFI = "ReachableWithWIFI"
let kNOTREACHABLE = "notReachable"
let kREACHABLEWITHWWAN = "ReachableWithWWAN"

var reachability: Reachability?
var reachabilityStatus = kREACHABILITYWITHWIFI

extension MovieCollectionViewController {
    
    //       var internetReach: Reachability?
    
    func statusChangedWithReachability(_ currentStatus: Reachability)
    {
        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
        
        print("Status: \(networkStatus.rawValue)")
        
        
        if networkStatus.rawValue == ReachableViaWiFi.rawValue
        {
            print("Reachable with Wifi")
            reachabilityStatus = kREACHABILITYWITHWIFI
            self.reachabilityImage.image = UIImage.init(named: "Green")
            self.reachabilityImage.isHidden = false
            self.view.addSubview(self.reachabilityImage)
            self.view.bringSubview(toFront: self.reachabilityImage)
            
            UIView.animate(withDuration: 1.3, animations: {
                self.reachabilityImage.alpha = 0.0
                
            })
            
            
            self.store.searchForMoviesWith(Search.randomSearch, completionHandler: { (true) in
//                OperationQueue.main.addOperation({
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndicator.isHidden = true
                    self.searchActivityIndicator.stopAnimating()
                }
//                })
            })
        
//            searchBar.isUserInteractionEnabled = true
        }
        else if networkStatus.rawValue == ReachableViaWWAN.rawValue
        {
            print("Reachable with WWAN")
            reachabilityStatus = kREACHABLEWITHWWAN
            
//            searchBar.isUserInteractionEnabled = true
            self.reachabilityImage.image = UIImage.init(named: "Green")
            self.reachabilityImage.isHidden = false
            self.view.addSubview(self.reachabilityImage)
            self.view.bringSubview(toFront: self.reachabilityImage)
            
            UIView.animate(withDuration: 1.3, animations: {
                self.reachabilityImage.alpha = 0.0
                
            })
            
            self.store.searchForMoviesWith(Search.randomSearch, completionHandler: { (true) in
//                OperationQueue.main.addOperation({
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndicator.isHidden = true
                    self.searchActivityIndicator.stopAnimating()
                }
//                })
            })
        }
        else if networkStatus.rawValue == NotReachable.rawValue
        {
            reachabilityStatus = kNOTREACHABLE
            print("Network not reachable")
            
            self.store.movieResults.removeAll()
            DispatchQueue.main.async(execute: {
                self.movieCollectionView.reloadData()
                self.searchActivityIndicator.isHidden = true
                self.searchActivityIndicator.stopAnimating()

                
            })
            
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot conduct search", preferredStyle: .alert)
            
            self.present(noNetworkAlertController, animated: true, completion: nil)
            
            DispatchQueue.main.async { () -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    noNetworkAlertController.dismiss(animated: true, completion: nil)
                    self.view.bringSubview(toFront: self.reachabilityImage)
                    self.reachabilityImage.isHidden = false
                    self.reachabilityImage.alpha = 1.0
                    self.reachabilityImage.image = UIImage.init(named: "Red")
                    self.view.addSubview(self.reachabilityImage)
                })
            }
            
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reachStatusChanged"), object: nil)
    }
    
    
    func reachabilityChanged(_ notification: Notification)
    {
        print("Reachability status changed")
        reachability = notification.object as? Reachability
        self.statusChangedWithReachability(reachability!)
    }
}
