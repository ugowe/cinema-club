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
    var movie: Movie?
    var delegate: MovieCollectionViewCellDelegate?
    
    func setMovie(_ movie: Movie) {
        self.movie = movie
        self.resetCell()
        
        if (movie.posterURL == "N/A") {
            self.movieTitle.text = movie.title
            self.movieYear.text = movie.year
            
        } else if movie.posterImage == nil {
            movie.getMovieImageWithCompletion({ success in
                if success && self.delegate!.canUpdateImageViewOfCell(self) {
                    
                    OperationQueue.main.addOperation({
                        self.movieImageView.alpha = 0
                        self.movieImageView.image! = movie.posterImage!
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.movieImageView.alpha = 1
                        })
                    })
                }
            })
        } else {
            self.movieImageView.image! = movie.posterImage!
        }
        
    }
    
    func resetCell(){
        self.movieImageView.image = nil
        self.movieTitle.text = nil
        self.movieYear.text = nil
    }
    
}


