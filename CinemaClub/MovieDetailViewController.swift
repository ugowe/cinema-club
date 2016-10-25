//
//  DetailViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/30/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//@available(iOS 10.0, *)
class MovieDetailViewController: UIViewController {
    
    let store = MovieDataStore.sharedStore
    var movie: Movie?
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var moviePlotTextView: UITextView!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieRatedLabel: UILabel!
    @IBOutlet weak var movieActorsLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "⭐️", style: .done, target: self, action: #selector(MovieDetailViewController.saveMovie))
        guard let unwrappedMovie = movie else{return}
        self.store.getMovieDetailsWithID(movie: unwrappedMovie) { success in
            
            DispatchQueue.main.async {
                self.movieTitleLabel.text = self.movie?.movieTitle
                self.movieYearLabel.text = "\((self.movie?.movieYear)!)   |   \((self.movie?.movieRuntime)!)"
                self.moviePlotTextView.text = self.movie?.moviePlotShort
                self.movieDirectorLabel.text = self.movie?.movieDirector
                self.movieActorsLabel.text = self.movie?.movieActors
                self.movieRatedLabel.text = self.movie?.movieRated
                self.movieGenreLabel.text = self.movie?.movieGenre
                
                if self.movie?.moviePosterURL == "N/A" {
                    self.moviePosterImageView.image = UIImage.init(named: "moviePlaceholder")
                }
                
                let imageString = self.movie?.moviePosterURL
                
                guard let unwrappedImageString = imageString else {print("Unable to unwrap imageString"); return}
                let posterImageURL = URL(string: unwrappedImageString)
                
                guard let url = posterImageURL else {print("Unable to unwrap imageString"); return}
                do {
                let imageData = try Data(contentsOf: url)
                self.moviePosterImageView.image = UIImage.init(data: imageData)
                    
                } catch {
                    print(error)
                }
            


            }
        }
//        
//        self.movieTitleLabel.text = self.movie?.movieTitle
//        self.movieYearLabel.text = "\((self.movie?.movieYear)!)   |   \((self.movie?.movieRuntime)!)"
//        self.moviePlotTextView.text = self.movie?.moviePlotShort
//        self.movieDirectorLabel.text = self.movie?.movieDirector
//        self.movieActorsLabel.text = self.movie?.movieActors
//        self.movieRatedLabel.text = self.movie?.movieRated
//        self.movieGenreLabel.text = self.movie?.movieGenre
        
    }
    
    func saveMovie() {
        guard let savedMovieTitle = self.movie?.movieTitle else {return}
        
        let savedAlert = UIAlertController.init(title: "Saved", message: "\(savedMovieTitle) has been saved to your Favorites", preferredStyle: .alert)
        self.present(savedAlert, animated: true, completion: nil)
        self.navigationItem.rightBarButtonItem = nil
        
        DispatchQueue.main.async { //() -> Void in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                savedAlert.dismiss(animated: true, completion: nil)
            })
        }
        
        let managedContext = store.managedObjectContext
        
        let addMovie = NSEntityDescription.insertNewObject(forEntityName: "Favorited", into: managedContext) as! Favorited
        
        guard let savedMovie = self.movie else {return}
        addMovie.movies?.insert(savedMovie)
        
        store.saveContext()        
    }

}












