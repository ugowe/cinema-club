//
//  OMDBAPIClient.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation

class OMDBAPIClient {
    
    static let sharedInstance = OMDBAPIClient()
    
    var pageNumber = 1
    //    var upcomingMovie : [UpcomingMovies] = []
    
    func getNextPage() {
        pageNumber += 1
    }
    
    func searchOMDBAPIWith(_ query: String, completionHandler: @escaping ([String: AnyObject]) -> ()) {
        
        let escapedQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.omdbapi.com/?s=\(escapedQuery)&page=\(pageNumber)"
       
       
        
        let session = URLSession.shared
        guard let movieURL = URL(string: urlString) else {print("Invalid URL"); return}
        
        let movieTask = session.dataTask(with: movieURL, completionHandler: { (data, response, error) in
            
            guard let data = data else {fatalError("Unable to retrieve data")}
            
            do {
                let movieDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                completionHandler(movieDictionary as! [String : AnyObject])
            } catch {
                print(error)
            }
        }) 
        movieTask.resume()

    }
    
    func getMovieDataSearchWithID(movieID: String, completion: @escaping ([String: AnyObject])-> ()) {
        let urlString = "https://www.omdbapi.com/?i=\(movieID)&plot=short"
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        guard let movieIdURL = url else {print("Invalid ID URL"); return}
        
        let movieTask = session.dataTask(with: movieIdURL) { (data, response, error) in
            guard let data = data  else {return}
            do {
                let movieData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                completion(movieData as! [String : AnyObject])
            } catch {
                print(error)
            }
        }
        movieTask.resume()
        
    }
}
