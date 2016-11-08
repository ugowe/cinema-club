//
//  FavoritedMovieTableViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 10/24/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class FavoritedMovieTableViewController: UITableViewController {
    
    let store = MovieDataStore.sharedStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        store.fetchData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        store.fetchData()
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return store.favoriteMovies.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritedMovieTableViewCell
        
        let favoriteMovie = store.favoriteMovies[(indexPath as NSIndexPath).row]
        
        cell.favMovieTitleLabel.text = favoriteMovie.movieTitle
        cell.favDirectorLabel.text = favoriteMovie.movieDirector
        cell.favActorsLabel.text = favoriteMovie.movieActors
        cell.favYearLabel.text = favoriteMovie.movieYear
        
        let imageString = favoriteMovie.moviePosterURL
        
        if let unwrappedString =  imageString {
            if unwrappedString == "N/A" {
                cell.favMoviePosterImageView.image = UIImage.init(named: "moviePlaceholder")
            }
            
            let posterImageURL = URL(string: unwrappedString)
            guard let url = posterImageURL else {fatalError("")}
            let imageFromData = try? Data(contentsOf: url)
            
            if let unwrappedImage = imageFromData {
                cell.favMoviePosterImageView.image = UIImage.init(data: unwrappedImage)
            }
        }
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let managedContext = store.managedObjectContext
            managedContext.delete(store.favoriteMovies[(indexPath as NSIndexPath).row])
            
            store.favoriteMovies.remove(at: (indexPath as NSIndexPath).row)
            store.saveContext()
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesToDetailSegue" {
            let destinationVC = segue.destination as? MovieDetailViewController
            
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            if let unwrappedIndexPath = indexPath {
                let favoriteMovie  = self.store.favoriteMovies[(unwrappedIndexPath as NSIndexPath).row].movie
                guard let movie = favoriteMovie else {return}
                
                guard let destinationVC = destinationVC else {return}
                destinationVC.movie = movie
            }
        }
        
    }
    
    
}
