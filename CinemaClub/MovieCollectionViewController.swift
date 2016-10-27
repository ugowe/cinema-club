//
//  MovieCollectionViewController.swift
//  CinemaClub
//
//  Created by Ugowe on 9/12/16.
//  Copyright © 2016 Ugowe. All rights reserved.
//

import Foundation
import UIKit

//let kREACHABILITYWITHWIFI = "ReachableWithWIFI"
//let kNOTREACHABLE = "notReachable"
//let kREACHABLEWITHWWAN = "ReachableWithWWAN"
//
//var reachability: Reachability?
//var reachabilityStatus = kREACHABILITYWITHWIFI
//
//@available(iOS 10.0, *)
class MovieCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchDisplayDelegate, MovieCollectionViewCellDelegate {
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(MovieCollectionViewController.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        internetReach = Reachability.forInternetConnection()
        internetReach?.startNotifier()
        
        self.statusChangedWithReachability(internetReach!)
        self.reachabilityImage.isHidden = true
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
//        if let flowLayout = movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.estimatedItemSize = CGSize(width: 1, height: 1) }
        
        self.noResultsFoundLabel.isHidden = true
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
        
        if store.movieResults.count == 0 {
            DispatchQueue.main.async(execute: {
                self.movieCollectionView.reloadData()
                showNoResultsAlert(currentVC: self)
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
            cell.displayedMovieTitle.isHidden = true
            cell.movieTitle.text = movie.movieTitle
            cell.movieYear.text = movie.movieYear
        }
        
        
        let imageUrlString = movie.moviePosterURL!
        
        let imageUrl = URL(string: imageUrlString)
        
        if let unwrappedImageUrl = imageUrl {
            
            let imageData = try? Data(contentsOf: unwrappedImageUrl)
            
            if let unwrappedImageData = imageData {
                
                DispatchQueue.main.async {
                    cell.displayedMovieTitle.text = movie.movieTitle
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
        
//        if segue.identifier == "movieToDetailSegue" {
//            let destinationVC = segue.destination as! MovieDetailViewController
//            
//            let indexPath = movieCollectionView.indexPath(for: sender as! UICollectionViewCell)
//            
//            if let unwrappedIndexPath = indexPath {
//                let movie = self.store.movieResults[(unwrappedIndexPath as NSIndexPath).row]
//
//                destinationVC.movie = movie
//            }
//        }
    }
    
    func setUpIntialView() {
        
        //        self.searchTerms = ["man"]
        
        // Set the footer view to be unhidden
        self.hideFooterView = true
        
//        var titleLabelHeightConstraint: NSLayoutConstraint?
//
//        if let title = movie?.movieTitle {
//            let size = CGSize(width: 120, height: 1000)
//            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
//            
//            if estimatedRect.size.height > 20 {
//                titleLabelHeightConstraint?.constant = 44
//            } else {
//                titleLabelHeightConstraint?.constant = 20
//            }
//            
//        }
        
        // Collection view Layout
        self.movieCollectionView?.contentInset = UIEdgeInsets(top: layoutSpacing, left: layoutSpacing, bottom: layoutSpacing, right: layoutSpacing)
        self.flowLayout?.minimumLineSpacing = (layoutSpacing - 20)
        self.flowLayout?.minimumInteritemSpacing = layoutSpacing
        let screenWidth = UIScreen.main.bounds.size.width
        let itemWidth = (screenWidth / 2) - ((self.flowLayout?.minimumInteritemSpacing)! / 2) - layoutSpacing
        let itemHeight = itemWidth / imageRatio
        self.flowLayout?.itemSize = CGSize(width: itemWidth, height: (itemHeight + 40))
        self.flowLayout?.footerReferenceSize = CGSize(width: screenWidth, height: footerViewHeight)
        

        
        self.store.searchForMoviesWith("man") { success in
            
            if success {
                OperationQueue.main.addOperation({
                    self.movieCollectionView?.reloadData()
                })
            }
        }
        
        
    }
    
//    func statusChangedWithReachability(_ currentStatus: Reachability)
//    {
//        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
//        
//        print("Status: \(networkStatus.rawValue)")
//        
//        
//        if networkStatus.rawValue == ReachableViaWiFi.rawValue
//        {
//            print("Reachable with Wifi")
//            reachabilityStatus = kREACHABILITYWITHWIFI
//            self.reachabilityImage.image = UIImage.init(named: "internetcheckMark.png")
//            self.reachabilityImage.isHidden = false
//            self.view.addSubview(self.reachabilityImage)
//            self.view.bringSubview(toFront: self.reachabilityImage)
//            
//            UIView.animate(withDuration: 1.3, animations: {
//                self.reachabilityImage.alpha = 0.0
//                
//            })
//            
//            let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
//            let randomSearch = randomSearchTerm[randomIndex]
//            
//            self.store.getMovieRepositories(randomSearch) {
//                OperationQueue.main.addOperation({
//                    self.movieCollectionView.reloadData()
//                    self.searchActivityIndictor.isHidden = true
//                    self.searchActivityIndictor.stopAnimating()
//                    
//                })
//            }
//            moviesSearchBar.isUserInteractionEnabled = true
//        }
//        else if networkStatus.rawValue == ReachableViaWWAN.rawValue
//        {
//            print("Reachable with WWAN")
//            reachabilityStatus = kREACHABLEWITHWWAN
//            
//            moviesSearchBar.isUserInteractionEnabled = true
//            self.reachabilityImage.image = UIImage.init(named: "internetcheckMark.png")
//            self.reachabilityImage.isHidden = false
//            self.view.addSubview(self.reachabilityImage)
//            self.view.bringSubview(toFront: self.reachabilityImage)
//            
//            UIView.animate(withDuration: 1.3, animations: {
//                self.reachabilityImage.alpha = 0.0
//                
//            })
//            
//            let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
//            let randomSearch = randomSearchTerm[randomIndex]
//            self.store.getMovieRepositories(randomSearch) {
//                OperationQueue.main.addOperation({
//                    self.movieCollectionView.reloadData()
//                    self.searchActivityIndictor.isHidden = true
//                    self.searchActivityIndictor.stopAnimating()
//                    
//                })
//            }
//        }
//        else if networkStatus.rawValue == NotReachable.rawValue
//        {
//            reachabilityStatus = kNOTREACHABLE
//            print("Network not reachable")
//            
//            self.store.movieArray.removeAll()
//            DispatchQueue.main.async(execute: {
//                self.movieCollectionView.reloadData()
//                self.searchActivityIndictor.isHidden = true
//                self.searchActivityIndictor.stopAnimating()
//                self.moviesSearchBar.isUserInteractionEnabled = false
//                
//            })
//            
//            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot conduct search", preferredStyle: .alert)
//            
//            self.present(noNetworkAlertController, animated: true, completion: nil)
//            
//            DispatchQueue.main.async { () -> Void in
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
//                    noNetworkAlertController.dismiss(animated: true, completion: nil)
//                    self.view.bringSubview(toFront: self.reachabilityImage)
//                    self.reachabilityImage.isHidden = false
//                    self.reachabilityImage.alpha = 1.0
//                    self.reachabilityImage.image = UIImage.init(named: "internetRedMark.png")
//                    self.view.addSubview(self.reachabilityImage)
//                })
//            }
//            
//            
//        }
//        
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "reachStatusChanged"), object: nil)
//    }
    
    
//    func reachabilityChanged(_ notification: Notification)
//    {
//        print("Reachability status changed")
//        reachability = notification.object as? Reachability
//        self.statusChangedWithReachability(reachability!)
//    }

    
    
}
