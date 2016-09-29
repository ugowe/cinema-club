//
//  MovieCollectionViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate, MovieCollectionViewCellDelegate {
    
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let store = MovieDataStore.sharedStore
    var movie: Movie?
    
    var searchBar: UISearchBar!
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
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        setUpIntialView()
        createSearchBar()
        
        
        //        // Register cell classes
        //        http://stackoverflow.com/questions/32166364/could-not-cast-value-of-type-uicollectionviewcell
        //        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func createSearchBar() {
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search Movies By Title"
        self.navigationItem.titleView = searchBar

        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.movieResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        
        cell.backgroundColor = UIColor.lightGray
        
        let movie = self.store.movieResults[indexPath.row]
        
        
        cell.movieTitle.text = movie.title
        cell.movieYear.text = movie.year
        
        if movie.posterURL == "N/A" {
            cell.movieImageView.image = UIImage.init(named: "moviePlaceholder")
        }
        
        let imageUrlString = movie.posterURL
        
        let imageUrl = URL(string: imageUrlString!)
        
        if let unwrappedImageUrl = imageUrl {
            let imageData = try? Data(contentsOf: unwrappedImageUrl)
            
            if let unwrappedImageData = imageData {
                cell.movieImageView.image = UIImage(data: unwrappedImageData)
            }
        }
        
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//        let movieCell: MovieCollectionViewCell = cell as! MovieCollectionViewCell
//        movieCell.delegate = self
//        //        let movie = self.store.movieResults[indexPath.row]
//        //
//        movieCell.placeHolderImageView.image = UIImage(named: "moviePlaceholder")!
//        //        movieCell.movieImageView.image = movie.posterImage
//        //        movieCell.movieTitle.text = movie.title
//        //        movieCell.movieYear.text = movie.year
//        //
//        //        if let dataArray = self.store.movieResults[indexPath.item] as? Movie {
//        //            movieCell.movie = dataArray
//        //        }
//        let dataArrayContainsMovies = (self.store.movieResults[indexPath.item] is Movie)
//        if dataArrayContainsMovies {
//            movieCell.movie = self.store.movieResults[indexPath.item]
//        }
//        
//        
//    }
    
    func canUpdateImageViewOfCell(_ cell: MovieCollectionViewCell) -> Bool {
        
        if ((self.movieCollectionView?.visibleCells.contains(cell)) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func setUpIntialView() {
        
//        self.searchTerms = ["man"]
        
        // Set the footer view to be unhidden
        self.hideFooterView = true
        
        // Collection view Layout
        self.movieCollectionView?.contentInset = UIEdgeInsets(top: layoutSpacing, left: layoutSpacing, bottom: layoutSpacing, right: layoutSpacing)
        self.flowLayout?.minimumLineSpacing = layoutSpacing
        self.flowLayout?.minimumInteritemSpacing = layoutSpacing
        let screenWidth = UIScreen.main.bounds.size.width
        let itemWidth = (screenWidth / 2) - ((self.flowLayout?.minimumInteritemSpacing)! / 2) - layoutSpacing
        let itemHeight = itemWidth / imageRatio
        self.flowLayout?.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.flowLayout?.footerReferenceSize = CGSize(width: screenWidth, height: footerViewHeight)
        
        
        
        
        self.store.searchForMoviesWith("man") { success in
            
            if success {
                OperationQueue.main.addOperation({ 
                    self.movieCollectionView?.reloadData()
                })
            }
        }
        
        
    }
    
    
}
