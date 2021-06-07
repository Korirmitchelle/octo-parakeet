//
//  Utils.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 08/06/2021.
//

import Foundation

class Utils{
    func delay(seconds: Double, completion:@escaping ()->()) {
        let when = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion()
        }
    }
}
