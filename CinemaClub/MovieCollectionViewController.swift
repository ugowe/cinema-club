//
//  MovieCollectionViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let store = MovieDataStore.sharedStore
    var movies: [Movie] = []
    var searchTerms: [String]?
    var searchString: String?
    var hideFooterView: Bool?
    var lastContentOffset: Float?
    
    var flowLayout: UICollectionViewFlowLayout?
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
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TO DO: Use count from datastore array
        return self.movies.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let movieCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        return movieCell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        var movieCell = cell as! MovieCollectionViewCell
        movieCell.delegate = self
        movieCell.placeHolderImageView.image = UIImage(named: "moviePlaceholder")!
        let dataArrayContainsMovies: Bool = self.movies[indexPath.item] === Movie.self
        if dataArrayContainsMovies {
            movieCell.movie = self.movies[indexPath.item]
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
                self.collectionView?.reloadData()
            }
        }
        
        
    }


}
