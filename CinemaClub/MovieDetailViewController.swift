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
    
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.moviePosterImageView.isHidden = true
        self.movieTitleLabel.isHidden = true
        self.movieYearLabel.isHidden = true
        self.moviePlotTextView.isHidden = true
        self.movieDirectorLabel.isHidden = true
        self.movieActorsLabel.isHidden = true
        self.movieGenreLabel.isHidden = true
        self.movieRatedLabel.isHidden = true
        
        self.directorLabel.isHidden = true
        self.actorsLabel.isHidden = true
        self.genreLabel.isHidden = true
        self.ratedLabel.isHidden = true
        self.activityIndicator.isHidden = true
        
        
        store.fetchData()
        checkData()
        reachabilityStatusChanged()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MovieDetailViewController.reachabilityStatusChanged), name: NSNotification.Name(rawValue: "reachStatusChanged"), object: nil)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "⭐️", style: .done, target: self, action: #selector(MovieDetailViewController.saveMovie))
        guard let unwrappedMovie = movie else{return}
        self.store.getMovieDetailsWithID(movie: unwrappedMovie) { success in
            
            DispatchQueue.main.async {
                self.movieTitleLabel.text = self.movie?.movieTitle
                self.movieYearLabel.text = "\((self.movie?.movieYear)!)   |   \((self.movie?.movieRuntime)!)"
                self.moviePlotTextView.text = self.movie?.moviePlotShort
                self.movieDirectorLabel.text = self.movie?.movieDirector
                self.movieActorsLabel.text = self.movie?.movieActors
                self.movieGenreLabel.text = self.movie?.movieGenre
                self.movieRatedLabel.text = self.movie?.movieRated
                
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
        
        //        guard let repoDictionary = self.movie as! [String: Any] else { fatalError("Object in array is of non-dictionary type") }
        guard let unwrappedMovie = movie else{return}
        self.store.getMovieDetailsWithID(movie: unwrappedMovie) { success in
            
            let favoritedMovieEntity = NSEntityDescription.entity(forEntityName: "FavoritedMovie", in: self.store.managedObjectContext)
            guard let entity = favoritedMovieEntity else {fatalError("Entity not working")}
            
            let savedMovie = FavoritedMovie(movie: unwrappedMovie, entity: entity, managedObjectContext: self.store.managedObjectContext)
            
            self.store.favoriteMovies.append(savedMovie)
            
            
            self.store.saveContext()
       
        }
        

        
    }
    
    func reachabilityStatusChanged(){
        if reachabilityStatus == kNOTREACHABLE {
            /// CHANGE
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot conduct search", preferredStyle: .alert)
            
            self.present(noNetworkAlertController, animated: true, completion: nil)
            
            DispatchQueue.main.async { () -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    noNetworkAlertController.dismiss(animated: true, completion: nil)
                })
            }
            
        }
        else if reachabilityStatus == kREACHABILITYWITHWIFI {
            
        }
        else if reachabilityStatus == kREACHABLEWITHWWAN {
            
        }
    }
    
    func checkData() {
        
        let favoriteRequest = NSFetchRequest<FavoritedMovie>(entityName: "FavoritedMovie")
        
        do{
            let object = try MovieDataStore.sharedStore.managedObjectContext.fetch(favoriteRequest)
            guard let movieObject = self.movie else {return}
            
            if object.count == 0 {
                MovieDataStore.sharedStore.getMovieDetailsWithID(movie: movieObject, completion: {
                    DispatchQueue.main.async {
                        self.moviePosterImageView.isHidden = false
                        self.movieTitleLabel.isHidden = false
                        self.movieYearLabel.isHidden = false
                        self.moviePlotTextView.isHidden = false
                        self.movieDirectorLabel.isHidden = false
                        self.movieActorsLabel.isHidden = false
                        self.movieGenreLabel.isHidden = false
                        self.movieRatedLabel.isHidden = false
                        
                        self.directorLabel.isHidden = false
                        self.actorsLabel.isHidden = false
                        self.genreLabel.isHidden = false
                        self.ratedLabel.isHidden = false
                        
                        self.movieTitleLabel.text = self.movie?.movieTitle
                        self.movieYearLabel.text = "\((self.movie?.movieYear)!)   |   \((self.movie?.movieRuntime)!)"
                        self.moviePlotTextView.text = self.movie?.moviePlotShort
                        self.movieDirectorLabel.text = self.movie?.movieDirector
                        self.movieActorsLabel.text = self.movie?.movieActors
                        self.movieGenreLabel.text = self.movie?.movieGenre
                        self.movieRatedLabel.text = self.movie?.movieRated
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                })
            }
            for movie in object {
                guard let favoritedMovieID = movie.movieID else {return}
                
                if object.count != 0 && favoritedMovieID == movieObject.movieID {
                    print("WE ALREADY HHHHHHHHHHHHHEEEEEEEEEEEEEHHHHHHEEEEE")
                    self.moviePosterImageView.isHidden = false
                    self.movieTitleLabel.isHidden = false
                    self.movieYearLabel.isHidden = false
                    self.moviePlotTextView.isHidden = false
                    self.movieDirectorLabel.isHidden = false
                    self.movieActorsLabel.isHidden = false
                    self.movieGenreLabel.isHidden = false
                    self.movieRatedLabel.isHidden = false
                    
                    self.directorLabel.isHidden = false
                    self.actorsLabel.isHidden = false
                    self.genreLabel.isHidden = false
                    self.ratedLabel.isHidden = false
                    
                    self.movieTitleLabel.text = self.movie?.movieTitle
                    guard let movieYear = self.movie?.movieYear,
                        let movieRuntime = self.movie?.movieRuntime else {return}
                    self.movieYearLabel.text = "\(movieYear)   |   \(movieRuntime)"
                    self.moviePlotTextView.text = self.movie?.moviePlotShort
                    self.movieDirectorLabel.text = self.movie?.movieDirector
                    self.movieActorsLabel.text = self.movie?.movieActors
                    self.movieGenreLabel.text = self.movie?.movieGenre
                    self.movieRatedLabel.text = self.movie?.movieRated
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                } else if favoritedMovieID != movieObject.movieID {
                    MovieDataStore.sharedStore.getMovieDetailsWithID(movie: movieObject, completion: {
                        DispatchQueue.main.async {
                            self.moviePosterImageView.isHidden = false
                            self.movieTitleLabel.isHidden = false
                            self.movieYearLabel.isHidden = false
                            self.moviePlotTextView.isHidden = false
                            self.movieDirectorLabel.isHidden = false
                            self.movieActorsLabel.isHidden = false
                            self.movieGenreLabel.isHidden = false
                            self.movieRatedLabel.isHidden = false
                            
                            self.directorLabel.isHidden = false
                            self.actorsLabel.isHidden = false
                            self.genreLabel.isHidden = false
                            self.ratedLabel.isHidden = false
                            
                            self.movieTitleLabel.text = self.movie?.movieTitle
                            self.movieYearLabel.text = "\((self.movie?.movieYear)!)   |   \((self.movie?.movieRuntime)!)"
                            self.moviePlotTextView.text = self.movie?.moviePlotShort
                            self.movieDirectorLabel.text = self.movie?.movieDirector
                            self.movieActorsLabel.text = self.movie?.movieActors
                            self.movieGenreLabel.text = self.movie?.movieGenre
                            self.movieRatedLabel.text = self.movie?.movieRated
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    })
                }
            }
            
        } catch {print("Error retrieving data")}
    }
    
    
}












