//
//  Movie+CoreDataProperties.swift
//  CinemaClub
//
//  Created by Ugowe on 10/22/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import CoreData

extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie");
    }

    @NSManaged public var movieActors: String?
    @NSManaged public var movieCountry: String?
    @NSManaged public var movieDirector: String?
    @NSManaged public var movieGenre: String?
    @NSManaged public var movieID: String?
    @NSManaged public var movieLanguage: String?
    @NSManaged public var movieMetascore: String?
    @NSManaged public var moviePlotLong: String?
    @NSManaged public var moviePlotShort: String?
    @NSManaged public var moviePosterURL: String?
    @NSManaged public var movieRated: String?
    @NSManaged public var movieRating: String?
    @NSManaged public var movieRuntime: String?
    @NSManaged public var movieTitle: String?
    @NSManaged public var movieWriter: String?
    @NSManaged public var movieYear: String?
    @NSManaged public var favorite: Favorited?

}
