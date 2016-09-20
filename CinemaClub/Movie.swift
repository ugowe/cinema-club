//
//  Movie.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    var title: String
    var year: String
    var imdbID: String
    var type: String
    var poster: String
    
    var actors: String?
    var director: String?
    var writer: String?
    var genre: String?
    var rating: String?
    var metascore: String?
    var plotShort: String?
    var imdbRating: String?
    
    var placeholderImage: UIImage?
    var posterImage: UIImage?
    
    
    init?(movieDictionary: [String: AnyObject]) {
        guard let
            jsonTitle = movieDictionary["Title"] as? String,
            jsonYear = movieDictionary["Year"] as? String,
            jsonImdbID = movieDictionary["imdbID"] as? String,
            jsonType = movieDictionary["Type"] as? String,
            jsonPoster = movieDictionary["Poster"] as? String
        
            else {fatalError("Error creating instance of Movie")}
        
        self.title = jsonTitle
        self.year = jsonYear
        self.imdbID = jsonImdbID
        self.type = jsonType
        self.poster = jsonPoster
    }
    
    func updateMovieObjectWithDetails(details:[String: String]){
        self.actors = details["Actors"]
        self.director = details["Director"]
        self.genre = details["Genre"]
        self.metascore = details["Metascore"]
        self.plotShort = details["Plot"]
        self.rating = details["Rated"]
        self.writer = details["Writer"]
        self.imdbRating = details["imdbRating"]
    }
    
    func getMovieImageWithCompletion(completion: (Bool) -> ()){
        
        NSOperationQueue.mainQueue().addOperationWithBlock { 
            
            guard let
                url = NSURL(string: self.poster),
                data = NSData(contentsOfURL: url)
                else {fatalError("Error retrieving poster image")}
            self.posterImage = UIImage(data: data)
            
            if (self.posterImage == nil){
                completion(false)
            } else {
                completion(true)
            }
            
        }
    }

    
}