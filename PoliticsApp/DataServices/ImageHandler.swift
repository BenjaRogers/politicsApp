//
//  ImageHandler.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/6/23.
//

import Foundation
import UIKit

// Needs work. Would like to pull images from https://github.com/unitedstates/images
// Example: https://theunitedstates.io/images/congress/[size]/[bioguide].jpg
// These will need to get resized and ideally trimmed to a circle like twitter though that will probably happen in the view?
class ImageHandler {
    func RequestImage(imageURL: String) -> Data? {
        let url = URL(string: "")!
        
        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {

            return data

        }
        return nil
    }
}
