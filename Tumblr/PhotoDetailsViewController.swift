//  Created by Bhalla, KapiL on 3/29/17.
//  Copyright © 2017 Bhalla, KapiL. All rights reserved.

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var movieDetailsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var url: String?
    var movieDesc: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setImageWith((URL(string: url!)!))
        movieDetailsLabel.text = movieDesc
        movieDetailsLabel.sizeToFit()
    }
}

class MovieDetails {
    // place the parts of the movie details here and set the object on segue prepare
}
