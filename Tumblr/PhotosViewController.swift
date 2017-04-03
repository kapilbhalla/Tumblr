
//  PhotosViewController.swift
//  Created by Bhalla, KapiL on 3/29/17.
//  Copyright © 2017 Bhalla, KapiL. All rights reserved.

import UIKit
import AFNetworking
import MBProgressHUD

class PhotosViewController: UIViewController, UITableViewDataSource {

    var posts: [NSDictionary]?
    var selectedCell: PhotoCell?

    @IBOutlet weak var tumblrTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        PhotosViewController.fetchMovies(successCallBack: setTableData, errorCallBack: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        tumblrTableView.insertSubview(refreshControl, at: 0)
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        PhotosViewController.fetchMovies(successCallBack: setTableData, errorCallBack: handleErrors)
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "com.tumblr.cell", for: indexPath) as! PhotoCell
        
        if let posts = self.posts {
            cell.movieTitle.text = posts[indexPath.row]["title"] as! String
            
            let movieDetails = posts[indexPath.row]["overview"] as! String
            cell.movieDetails.text = movieDetails
            let posterPath = posts[indexPath.row]["poster_path"] as! String
            let posterSize = "/w92"
            let fullSize = "/original"
            let posterImgUrl = "https://image.tmdb.org/t/p" + posterSize + posterPath
            let fullImageUrl = "https://image.tmdb.org/t/p" + fullSize + posterPath
        
            cell.mainImageURL = fullImageUrl
            cell.movieDesc = movieDetails
            cell.avatarImg.setImageWith(URL(string: posterImgUrl)!)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        }
        return 0

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let cell = sender as! PhotoCell

        let destination = segue.destination as! PhotoDetailsViewController
        destination.url = cell.mainImageURL
        destination.movieDesc = cell.movieDesc
    }


    func setTableData (movies: NSDictionary) {
        // Hide HUD once the network request comes back (must be done on main UI thread)
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.posts = movies["results"] as! [NSDictionary]
        self.tumblrTableView.reloadData()
    }
    
    func handleErrors (error: Error?){
        let errorMessage = "check network connectivity"
        let alertController = UIAlertController(title: "Network Error", message: errorMessage, preferredStyle: .actionSheet)
    }
    
    class func fetchMovies(successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                errorCallBack?(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                //print(dataDictionary)
                successCallBack(dataDictionary)
            }
        }
        task.resume()
    }
}

class PhotoCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var movieDetails: UILabel!
    @IBOutlet weak var movieTitle: UILabel!

    var mainImageURL: String?
    var movieDesc: String?
}


