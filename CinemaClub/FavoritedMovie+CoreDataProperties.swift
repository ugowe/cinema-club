//
//  FavoritedMovie+CoreDataProperties.swift
//  
//
//  Created by Ugowe on 11/3/16.
//
//

import Foundation
import CoreData


extension FavoritedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritedMovie> {
        return NSFetchRequest<FavoritedMovie>(entityName: "FavoritedMovie");
    }

    @NSManaged public var movieActors: String?
    @NSManaged public var movieCountry: String?
    @NSManaged public var movieDirector: String?
    @NSManaged public var movieGenre: String?
    @NSManaged public var movieID: String?
    @NSManaged public var moviePosterURL: String?
    @NSManaged public var movieMetaScore: String?
    @NSManaged public var moviePlotShort: String?
    @NSManaged public var moviePlotLong: String?
    @NSManaged public var movieRated: String?
    @NSManaged public var movieRating: String?
    @NSManaged public var movieRuntime: String?
    @NSManaged public var movieTitle: String?
    @NSManaged public var movieWriter: String?
    @NSManaged public var movieYear: String?
    @NSManaged public var movieLanguage: String?
    @NSManaged public var movie: Movie?

}
