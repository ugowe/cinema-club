//
//  FavoritedMovie+CoreDataClass.swift
//
//
//  Created by Ugowe on 11/3/16.
//
//

import Foundation
import CoreData


public class FavoritedMovie: NSManagedObject {
    
    convenience init(movie: Movie, entity: NSEntityDescription, managedObjectContext: NSManagedObjectContext) {
        
        self.init(entity: entity, insertInto: managedObjectContext)
//        
//        guard let
//            title = movie["Title"],
//            let year = dictionary["Year"] as? String,
//            let imdbID = dictionary["imdbID"] as? String,
//            let posterURL = dictionary["Poster"] as? String
//            
//            else {print("Something is wrong in the Movie Class"); return}
        

        self.movieTitle = movie.movieTitle
        self.movieYear = movie.movieYear
//        self.movieID = movie.movieID
        self.moviePosterURL = movie.moviePosterURL
        self.movieActors = movie.movieActors
        self.movieDirector = movie.movieDirector
        self.movieGenre = movie.movieGenre
        
    }
    
}
