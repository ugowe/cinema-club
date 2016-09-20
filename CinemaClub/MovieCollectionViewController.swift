//
//  MovieCollectionViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MovieCollectionViewCellDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let store = MovieDataStore.sharedStore
    var searchTerms: [String]?
    var searchString: String?
    var hideFooterView: Bool?
    var lastContentOffset: Float?
    
    
    let imageRatio: CGFloat = 0.66
    let layoutSpacing: CGFloat = 35.0
    let footerViewHeight: CGFloat = 65

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TO DO: add search bar to nav bar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
//        self.store.searchForMoviesWith("love") { success in
//            
//            if success {
//                self.collectionView?.reloadData()
//            }
//        }
        
        setUpIntialView()
        
//        // Register cell classes
//        http://stackoverflow.com/questions/32166364/could-not-cast-value-of-type-uicollectionviewcell
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TO DO: Use count from datastore array
        return self.store.movieResults.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
//        let movie = self.store.movieResults[indexPath.row]
//        
//        cell.movieImageView.image = movie.posterImage
//        cell.movieTitle.text = movie.title
//        cell.movieYear.text = movie.year
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let movieCell: MovieCollectionViewCell = cell as! MovieCollectionViewCell
        movieCell.delegate = self
        let movie = self.store.movieResults[indexPath.row]
        
        movieCell.placeHolderImageView.image = UIImage(named: "moviePlaceholder")!
        movieCell.movieImageView.image = movie.posterImage
        movieCell.movieTitle.text = movie.title
        movieCell.movieYear.text = movie.year
        
        if let dataArray = self.store.movieResults[indexPath.item] as? Movie {
            movieCell.movie = dataArray
        }
//        let dataArrayContainsMovies = (self.store.movieResults[indexPath.item] is Movie)
//        if dataArrayContainsMovies {
//            movieCell.movie = self.store.movieResults[indexPath.item]
//        }
        
        
    }
    
    func canUpdateImageViewOfCell(cell: MovieCollectionViewCell) -> Bool {
        
        if ((self.collectionView?.visibleCells().contains(cell)) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func setUpIntialView() {
        
        self.searchTerms = ["man"]
        
        // Set the footer view to be unhidden
        self.hideFooterView = true
        
        // Collection view Layout
        self.collectionView?.contentInset = UIEdgeInsets(top: layoutSpacing, left: layoutSpacing, bottom: layoutSpacing, right: layoutSpacing)
        self.flowLayout?.minimumLineSpacing = layoutSpacing
        self.flowLayout?.minimumInteritemSpacing = layoutSpacing
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let itemWidth = (screenWidth / 2) - ((self.flowLayout?.minimumInteritemSpacing)! / 2) - layoutSpacing
        let itemHeight = itemWidth / imageRatio
        self.flowLayout?.itemSize = CGSizeMake(itemWidth, itemHeight)
        self.flowLayout?.footerReferenceSize = CGSizeMake(screenWidth, footerViewHeight)
        
        
        
        
        self.store.searchForMoviesWith("love") { success in
            
            if success {
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    self.collectionView?.reloadData()
                })
            }
        }
        
        
    }


}
