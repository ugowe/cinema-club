//
//  OMDBAPIClient.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation

class OMDBAPIClient {
    
    class func searchOMDBAPIWith(query: String, completionHandler: ([String: AnyObject]) -> ()) {
        
        let urlString = "https://www.omdbapi.com/?s="
        let escapedQuery = query.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let movieType = "&type=movie"
        let urlStringAndQuery = urlString + escapedQuery + movieType
        
        let session = NSURLSession.sharedSession()
        guard let movieURL = NSURL(string: urlStringAndQuery) else {print("Invalid URL"); return}
        
        let movieTask = session.dataTaskWithURL(movieURL) { (data, response, error) in
            do {
                guard let data = data else {fatalError("Unable to retrive data")}
                let movieDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                completionHandler(movieDictionary as! [String : AnyObject])
            } catch {
                print(error)
            }
        }
        movieTask.resume()

    }
}