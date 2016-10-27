//
//  MovieCollectionViewCell.swift
//  CinemaClub
//
//  Created by Ugowe on 9/14/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func canUpdateImageViewOfCell(_ cell: MovieCollectionViewCell) -> Bool
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var displayedMovieTitle: UILabel!
    var movie: Movie?
    var delegate: MovieCollectionViewCellDelegate?
    
    
    
//    func createMovie(_ movie: Movie) {
//        self.movie = movie
//        self.resetCell()
//        
//        if (movie.moviePosterURL == "N/A") {
//            self.movieTitle.text = movie.movieTitle
//            self.movieYear.text = movie.movieYear
//            
//            
//            
//        }
//        
//    }
    
    
    
    //    } else if movie.posterImage == nil {
    //    movie.getMovieImageWithCompletion({ success in
    //    if success && self.delegate!.canUpdateImageViewOfCell(self) {
    //
    //    OperationQueue.main.addOperation({
    //    self.movieImageView.alpha = 0
    //    self.movieImageView.image! = movie.posterImage!
    //
    //    UIView.animate(withDuration: 0.5, animations: {
    //    self.movieImageView.alpha = 1
    //    })
    //    })
    //    }
    //    })
    //    } else {
    //    self.movieImageView.image! = movie.posterImage!
    //    }
    
    func resetCell(){
        self.movieImageView.image = nil
        self.movieTitle.text = nil
        self.movieYear.text = nil
        self.displayedMovieTitle.text = nil
    }
    
}


