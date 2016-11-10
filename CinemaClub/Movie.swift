//
//  Movie.swift
//  CinemaClub
//
//  Created by Ugowe on 11/3/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Movie: NSObject {
    
    public var movieActors: String?
    public var movieCountry: String?
    public var movieDirector: String?
    public var movieGenre: String?
    public var movieID: String?
    public var movieLanguage: String?
    public var movieMetascore: String?
    public var moviePlotLong: String?
    public var moviePlotShort: String?
    public var moviePosterURL: String?
    public var movieRated: String?
    public var movieRating: String?
    public var movieRuntime: String?
    public var movieTitle: String?
    public var movieWriter: String?
    public var movieYear: String?
//    public var placeholderImage: UIImage?
    
    //    @NSManaged public var movieDictionary: [String: Any]?
    
    //    init(dictionary: [String: Any])
    
    //    init(dictionary: [String: Any], entity: NSEntityDescription, managedObjectContext: NSManagedObjectContext) {
    //
    //
    //        super.init(entity: entity, insertInto: managedObjectContext)
    //        self.movieDictionary = dictionary
    //    }
    
    
//    convenience init(dictionary: [String: Any]) {
//        
////        self.init(entity: entity, insertInto: insertInto)
//        self.init()
//        
//        guard let
//            title = dictionary["Title"] as? String,
//            let year = dictionary["Year"] as? String,
//            let imdbID = dictionary["imdbID"] as? String,
//            let posterURL = dictionary["Poster"] as? String
//            
//            else {print("Something is wrong in the Movie Class"); return}
//        
//        self.movieTitle = title
//        self.movieYear = year
//        self.movieID = imdbID
//        self.moviePosterURL = posterURL
//        
//    }
    
    init(dictionary: [String: Any]) {
        super.init()
        
        self.updateMovieObjectWithDictionary(dictionary)
    }
    
    func updateMovieObjectWithDictionary(_ dictionary: [String: Any]){
        self.movieTitle = dictionary["Title"] as! String?
        self.movieYear = dictionary["Year"] as! String?
        self.movieID = dictionary["imdbID"] as! String?
        self.moviePosterURL = dictionary["Poster"] as! String?
    }
    
    
    
    func updateMovieObjectWithDetails(_ details:[String: AnyObject], completion:(Bool) -> ()){
        self.movieActors = details["Actors"] as? String
        self.movieDirector = details["Director"] as? String
        self.movieGenre = details["Genre"] as? String
        self.movieMetascore = details["Metascore"] as? String
        self.moviePlotShort = details["Plot"] as? String
        self.movieRated = details["Rated"] as? String
        self.movieWriter = details["Writer"] as? String
        self.movieRating = details["imdbRating"] as? String
        self.movieRuntime = details["Runtime"] as? String
        self.movieCountry = details["Country"] as? String
        self.movieLanguage = details["Language"] as? String
        
        completion(true)
    }

    func updateMovieWithFullPlotSummary(_ dictionary: NSDictionary, completion:(Bool) -> ()){
        self.moviePlotLong = dictionary["Plot"] as? String
        completion(true)
    }
}
