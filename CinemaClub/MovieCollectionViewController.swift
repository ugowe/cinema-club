//
//  MovieCollectionViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 10.0, *)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchResult = searchBar.text!
        
        if !searchResult.isEmpty {
            let queue = OperationQueue()
            queue.qualityOfService = .background
            queue.addOperation({ 
                self.store.searchForMoviesWith(searchResult, completionHandler: { (true) in
                    
                    OperationQueue.main.addOperation({ 
                        self.movieCollectionView.reloadData()
                    })
                })
            })
            
        }
        
        self.searchBar.resignFirstResponder()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.movieResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.backgroundColor = UIColor.lightGray
        
        let movie = self.store.movieResults[indexPath.row]
        
        cell.movieTitle.isHidden = true
        cell.movieYear.isHidden = true
        
        if movie.moviePosterURL == "N/A" {
            cell.movieImageView.image = UIImage.init(named: "moviePlaceholder")
            cell.movieTitle.isHidden = false
            cell.movieYear.isHidden = false
            cell.movieTitle.text = movie.movieTitle
            cell.movieYear.text = movie.movieYear
        }
        
        let imageUrlString = movie.moviePosterURL!
        
        let imageUrl = URL(string: imageUrlString)
        
        if let unwrappedImageUrl = imageUrl {
            
            let imageData = try? Data(contentsOf: unwrappedImageUrl)
            
            if let unwrappedImageData = imageData {
                
                DispatchQueue.main.async {
                    cell.movieImageView.image = UIImage(data: unwrappedImageData)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "movieToDetailSegue", sender: indexPath)
        
        let cell = movieCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.cyan
        
    }
    
    func canUpdateImageViewOfCell(_ cell: MovieCollectionViewCell) -> Bool {
        
        if ((self.movieCollectionView?.visibleCells.contains(cell)) != nil) {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "movieToDetailSegue" {
            if let selectedIndexPath = sender as? IndexPath {
                let destinationVC = segue.destination as! MovieDetailViewController
                let movieID = self.store.movieResults[selectedIndexPath.row]
                destinationVC.movie = movieID
            }
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
