//
//  FavoritedMovieTableViewCell.swift
//  CinemaClub
//
//  Created by Ugowe on 10/24/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit

class FavoritedMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favMovieTitleLabel: UILabel!
    @IBOutlet weak var favDirectorLabel: UILabel!
    @IBOutlet weak var favActorsLabel: UILabel!
    @IBOutlet weak var favYearLabel: UILabel!
    @IBOutlet weak var favMoviePosterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
