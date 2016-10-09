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

@available(iOS 10.0, *)
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
        
        guard let unwrappedMovie = movie else{return}
        self.store.getMovieDetailsWithID(movie: unwrappedMovie) { success in
            
            DispatchQueue.main.async {
                self.movieTitleLabel.text = self.movie?.movieTitle
                self.movieYearLabel.text = self.movie?.movieYear
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
        
        self.movieTitleLabel.text = self.movie?.movieTitle
        self.movieYearLabel.text = self.movie?.movieYear
        self.moviePlotTextView.text = self.movie?.moviePlotShort
        self.movieDirectorLabel.text = self.movie?.movieDirector
        self.movieActorsLabel.text = self.movie?.movieActors
        self.movieRatedLabel.text = self.movie?.movieRated
        self.movieGenreLabel.text = self.movie?.movieGenre
        
    }

}


