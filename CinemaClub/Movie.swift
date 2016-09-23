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
    
    var title: String?
    var year: String?
    var imdbID: String?
    var type: String?
    var posterURL: String?
    
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
    
    
//    init?(movieDictionary: [String: AnyObject]) {
//        guard let
//            jsonTitle = movieDictionary["Title"] as? String,
//            let jsonYear = movieDictionary["Year"] as? String,
//            let jsonImdbID = movieDictionary["imdbID"] as? String,
//            let jsonType = movieDictionary["Type"] as? String,
//            let jsonPoster = movieDictionary["Poster"] as? String
//        
//            else {fatalError("Error creating instance of Movie")}
//        
//        self.title = jsonTitle
//        self.year = jsonYear
//        self.imdbID = jsonImdbID
//        self.type = jsonType
//        self.posterURL= jsonPoster
//    }
    
    init(dictionary: [String: Any]) {
        
        self.updateMovieObject(fromDictionary: dictionary)
        
    }
    
    
    func updateMovieObject(fromDictionary dictionary: [String: Any]) {
        self.posterURL = dictionary["Poster"] as? String
        self.title = dictionary["Title"] as? String
        self.type = dictionary["Type"] as? String
        self.year = dictionary["Year"] as? String
        self.imdbID = dictionary["imdbID"] as? String
        self.placeholderImage = UIImage(named: "defaultMovieReel")!
    }
    
    func updateMovieObjectWithDetails(_ details:[String: String]){
        self.actors = details["Actors"]
        self.director = details["Director"]
        self.genre = details["Genre"]
        self.metascore = details["Metascore"]
        self.plotShort = details["Plot"]
        self.rating = details["Rated"]
        self.writer = details["Writer"]
        self.imdbRating = details["imdbRating"]
    }
    
    func getMovieImageWithCompletion(_ completion: @escaping (_ success: Bool) -> Void){
        
        OperationQueue.main.addOperation { 
            
            guard let
                url = URL(string: self.posterURL!),
                let data = try? Data(contentsOf: url)
                else {fatalError("Error retrieving posterURLimage")}
            self.posterImage = UIImage(data: data)
            
            if (self.posterImage == nil){
                completion(false)
            } else {
                completion(true)
            }
            
        }
    }

    
}
