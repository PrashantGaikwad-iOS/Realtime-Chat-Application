//
//  Extensions.swift
//  Chat Application
//
//  Created by Prashant G on 11/20/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        // check cache for image first
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = cacheImage as? UIImage
            return
        }
        
        // otherwise download the image and cache it
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, respose, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            }.resume()
    }
    
}
