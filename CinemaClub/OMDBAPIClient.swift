//
//  OMDBAPIClient.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation

class OMDBAPIClient {
    
    class func searchOMDBAPIWith(_ query: String, completionHandler: @escaping ([String: AnyObject]) -> ()) {
        
        let urlString = "https://www.omdbapi.com/?s="
        let escapedQuery = query.replacingOccurrences(of: " ", with: "+")
        let movieType = "&type=movie"
        let urlStringAndQuery = urlString + escapedQuery + movieType
        
        let session = URLSession.shared
        guard let movieURL = URL(string: urlStringAndQuery) else {print("Invalid URL"); return}
        
        let movieTask = session.dataTask(with: movieURL, completionHandler: { (data, response, error) in
            do {
                guard let data = data else {fatalError("Unable to retrive data")}
                let movieDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                completionHandler(movieDictionary as! [String : AnyObject])
            } catch {
                print(error)
            }
        }) 
        movieTask.resume()

    }
}
