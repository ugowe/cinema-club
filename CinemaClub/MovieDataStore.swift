//
//  MovieDataStore.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation


class MovieDataStore {
    
    static let sharedStore = MovieDataStore()
    var movieResults: [Movie] = []
    var totalNumberOfSearchResults: Int?
    
    // This private init is what allows us to ensure that people aren't creating multiple instances of the singleton
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    func searchForMoviesWith(query: String, completionHandler: (Bool) -> ()) {
        
        OMDBAPIClient.searchOMDBAPIWith(query) { results in
            
            self.movieResults.removeAll()
            self.totalNumberOfSearchResults = (results["totalResults"]?.integerValue)
            
            guard let resultsArray = results["Search"] as? NSArray else {fatalError("Error returning resultsArray")}
            
            for dictionary in resultsArray {
                
                if let movie = Movie(movieDictionary: dictionary as! [String : AnyObject]) {
                   self.movieResults.append(movie)
                }
                
            }
            if self.movieResults.count > 0{
                completionHandler(true)
            }
            
            print(self.movieResults)
            
        }
    }
    
}