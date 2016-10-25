//
//  Movie+CoreDataClass.swift
//  CinemaClub
//
//  Created by Ugowe on 10/22/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Movie: NSManagedObject {

    
    //    @NSManaged public var movieDictionary: [String: Any]?
    
    //    init(dictionary: [String: Any])
    
    //    init(dictionary: [String: Any], entity: NSEntityDescription, managedObjectContext: NSManagedObjectContext) {
    //
    //
    //        super.init(entity: entity, insertInto: managedObjectContext)
    //        self.movieDictionary = dictionary
    //    }
    
    
    convenience init(dictionary: [String: Any], entity: NSEntityDescription, insertInto: NSManagedObjectContext) {
        
        self.init(entity: entity, insertInto: insertInto)
        
        guard let
            title = dictionary["Title"] as? String,
            let year = dictionary["Year"] as? String,
            let imdbID = dictionary["imdbID"] as? String,
            let posterURL = dictionary["Poster"] as? String
            
            else {print("Somothing is wrong in the Movie Class"); return}
        
        self.movieTitle = title
        self.movieYear = year
        self.movieID = imdbID
        self.moviePosterURL = posterURL
        
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
        //        self.moviePlotLong = details[""]
        
        completion(true)
    }
    
    //    func getMovieImageWithCompletion(_ completion: @escaping (_ success: Bool) -> Void){
    //
    //        OperationQueue.main.addOperation {
    //
    //            guard let
    //                url = URL(string: self.moviePosterURL!),
    //                let data = try? Data(contentsOf: url)
    //                else {fatalError("Error retrieving posterURLimage")}
    //            self.posterImage = UIImage(data: data)
    //
    //            if (self.posterImage == nil){
    //                completion(false)
    //            } else {
    //                completion(true)
    //            }
    //            
    //        }
    //    }
}
