//
//  Favorited+CoreDataProperties.swift
//  CinemaClub
//
//  Created by Ugowe on 10/5/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import CoreData

extension Favorited {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorited> {
        return NSFetchRequest<Favorited>(entityName: "Favorited");
    }

    @NSManaged public var movies: Set<Movie>?

}

// MARK: Generated accessors for movies
extension Favorited {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: Movie)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: Movie)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}
