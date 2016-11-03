//
//  MovieCollectionViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//


import UIKit

//let kREACHABILITYWITHWIFI = "ReachableWithWIFI"
//let kNOTREACHABLE = "notReachable"
//let kREACHABLEWITHWWAN = "ReachableWithWWAN"
//
//var reachability: Reachability?
//var reachabilityStatus = kREACHABILITYWITHWIFI
//
//@available(iOS 10.0, *)
class MovieCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var reachabilityImage: UIImageView!
    @IBOutlet weak var noResultsFoundLabel: UILabel!
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    
    let store = MovieDataStore.sharedStore
    var movie: Movie?
    
    var searchBar: UISearchBar!
    var searchTerms: [String]?
    var searchString: String?
    
    var internetReach: Reachability?
    

    
    var hideFooterView: Bool?
    var lastContentOffset: Float?
    
    
    let imageRatio: CGFloat = 0.66
    let layoutSpacing: CGFloat = 35.0
    let footerViewHeight: CGFloat = 65
    
    deinit{
        print("Just because")
    }
    
    override func viewDidLoad() {
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
//        searchBar.delegate = self
        
        self.tabBarController?.navigationItem.title = "Movie Search"
        
        NotificationCenter.default.addObserver(self, selector: #selector(MovieCollectionViewController.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        internetReach = Reachability.forInternetConnection()
        internetReach?.startNotifier()
        self.statusChangedWithReachability(internetReach!)
        self.reachabilityImage.isHidden = true
        
        self.searchActivityIndicator.isHidden = false
        self.searchActivityIndicator.startAnimating()
        self.title = "Movie Search"
        

        self.noResultsFoundLabel.isHidden = true
        setUpIntialView()
        createSearchBar()
        super.viewDidLoad()
        
                //        if let flowLayout = movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.estimatedItemSize = CGSize(width: 1, height: 1) }
        
        //        // Register cell classes
        //        http://stackoverflow.com/questions/32166364/could-not-cast-value-of-type-uicollectionviewcell
        //        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        guard let flowLayout = movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//        
//        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
//            //Landscape
//        } else {
//            //Portrait
//        }
//        
//        flowLayout.invalidateLayout()
//    }
    
    func createSearchBar() {
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search Movies By Title"
        self.navigationItem.titleView = searchBar
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchText = searchBar.text!
        
//        if !searchText.isEmpty {
//                self.store.searchForMoviesWith(searchText, completionHandler: { (true) in
//
//                    DispatchQueue.main.async {
//                        self.movieCollectionView.reloadData()
//                    }
//                })
//        }
//        else
        
            if searchText.isEmpty {
            self.store.movieResults.removeAll()
            
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
        
        else if !searchText.isEmpty {
            self.store.movieResults.removeAll()
            self.store.API.pageNumber = 1
            self.store.searchForMoviesWith(searchText, completionHandler: { success in
                if success {
                    
                    DispatchQueue.main.async {
                        self.movieCollectionView.reloadData()
                    }
                    
                }
            })
        }

        if store.movieResults.count == 0 {
            DispatchQueue.main.async(execute: {
                self.movieCollectionView.reloadData()
                self.noResultsFoundLabel.isHidden = false
                self.view.addSubview(self.noResultsFoundLabel)
                self.view.bringSubview(toFront: self.noResultsFoundLabel)
                self.noResultsFoundLabel.text = "No Results"
//                showNoResultsAlert(currentVC: self)
            })
        }
        
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 1
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.movieResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        guard self.store.movieResults.count > 0 else { return cell }
        
        let movie = self.store.movieResults[indexPath.row]
        
        cell.movieTitle.isHidden = true
        cell.movieYear.isHidden = true
        
        if let unwrappedMoviePoster = self.store.movieResults[(indexPath as NSIndexPath).row].moviePosterURL {
            if unwrappedMoviePoster == "N/A" {
                DispatchQueue.main.async {
                    cell.movieImageView.image = UIImage.init(named: "moviePlaceholder")
//                    cell.movieTitle.isHidden = false
//                    cell.movieYear.isHidden = false
                    cell.displayedMovieTitle.isHidden = false
                    cell.movieTitle.text = movie.movieTitle
                    cell.movieYear.text = movie.movieYear
                }
                
            }
            
            
            let imageUrl = URL(string: unwrappedMoviePoster)
            
            if let unwrappedImageUrl = imageUrl {
                
                let imageData = try? Data(contentsOf: unwrappedImageUrl)
                
                if let unwrappedImageData = imageData {
                    
                    DispatchQueue.main.async {
                        cell.displayedMovieTitle.text = movie.movieTitle
                        cell.movieImageView.image = UIImage.init(data: unwrappedImageData)
                        self.noResultsFoundLabel.isHidden = true
                        //                        self.searchActivityIndicator.isHidden = true
                        //                        self.searchActivityIndicator.stopAnimating()
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "movieToDetailSegue", sender: indexPath)
        
        let cell = movieCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        
    }
    
//    func canUpdateImageViewOfCell(_ cell: MovieCollectionViewCell) -> Bool {
//        
//        if ((self.movieCollectionView?.visibleCells.contains(cell)) != nil) {
//            return true
//        } else {
//            return false
//        }
//    }
//    
    //if bottom of collection view is reached, get more
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if (indexPath as NSIndexPath).row == self.store.movieResults.count - 1 {
            
            if let searchText = searchBar.text {
                //                let search = searchText.replacingOccurrences(of: " ", with: "+").lowercased()
                
                if searchText == "" {
                    self.store.API.getNextPage()
                    self.store.searchForMoviesWith(Search.randomSearch, completionHandler: {_ in
                        DispatchQueue.main.async(execute: {
                            
                            self.movieCollectionView.reloadData()
                            print(self.store.movieResults.count)
                            
                        })
                        
                    })
                }
                else if searchText != "" {
                    self.store.API.getNextPage()
                    self.store.searchForMoviesWith(searchText, completionHandler: {_ in
                        DispatchQueue.main.async(execute: {
                            
                            self.movieCollectionView.reloadData()
                            print(self.store.movieResults.count)
                            
                        })
                    })
                }
                
            }
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
        
//                if segue.identifier == "movieToDetailSegue" {
//                    let destinationVC = segue.destination as! MovieDetailViewController
//        
//                    let indexPath = movieCollectionView.indexPath(for: sender as! MovieCollectionViewCell)
//        
//                    if let unwrappedIndexPath = indexPath {
//                        let movie = self.store.movieResults[(unwrappedIndexPath as IndexPath).row]
//        
//                        destinationVC.movie = movie
//                    }
//                }
    }
    
    func setUpIntialView() {
        
        
        // Collection view Layout
        self.movieCollectionView?.contentInset = UIEdgeInsets(top: layoutSpacing, left: layoutSpacing, bottom: layoutSpacing, right: layoutSpacing)
        self.flowLayout?.minimumLineSpacing = (layoutSpacing - 20)
        self.flowLayout?.minimumInteritemSpacing = layoutSpacing
        let screenWidth = UIScreen.main.bounds.size.width
        let itemWidth = (screenWidth / 2) - ((self.flowLayout?.minimumInteritemSpacing)! / 2) - layoutSpacing
        let itemHeight = itemWidth / imageRatio
        self.flowLayout?.itemSize = CGSize(width: itemWidth, height: (itemHeight + 40))
        self.flowLayout?.footerReferenceSize = CGSize(width: screenWidth, height: footerViewHeight)
        
        
        
        self.store.searchForMoviesWith(Search.randomSearch) { (true) in
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
        
        
    }
    
    
    
    
    
}
