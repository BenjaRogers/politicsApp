//
//  ImageHandler.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/6/23.
//

import Foundation
import UIKit

//NO LONGER IN USE - REPLACED BY ASYNCIMAGE CONTROL

// Needs work. Would like to pull images from https://github.com/unitedstates/images
// Example: https://theunitedstates.io/images/congress/[size]/[bioguide].jpg
// These will need to get resized and ideally trimmed to a circle like twitter though that will probably happen in the view?
class ImageHandler {
    func RequestImage(sponsor_id: String) -> UIImage? {
        let url = URL(string: "https://theunitedstates.io/images/congress/225x275/\(sponsor_id).jpg")
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            return image
        }
        return nil
    }
}
