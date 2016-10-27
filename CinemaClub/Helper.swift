//
//  Helper.swift
//  CinemaClub
//
//  Created by Ugowe on 10/25/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

func showNoResultsAlert(currentVC: MovieCollectionViewController) {
    let noResultsAlert = UIAlertController.init(title: "No Results Found", message: "No results found. Please search again.", preferredStyle: .alert)
    currentVC.present(noResultsAlert, animated: true, completion: nil)
    currentVC.navigationItem.rightBarButtonItem = nil
    
    DispatchQueue.main.async { //() -> Void in
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.9 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            noResultsAlert.dismiss(animated: true, completion: nil)
        })
    }
}

