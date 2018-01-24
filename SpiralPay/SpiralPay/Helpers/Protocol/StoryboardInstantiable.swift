//
//  StoryInstantiable.swift
//  AHStoryboard
//
//  Created by Apple on 08/01/18.
//  Copyright © 2018 Andyy Hope. All rights reserved.
//

import Foundation
import UIKit


public protocol StoryboardInstantiable { }

extension StoryboardInstantiable where Self: UIViewController {
    static func create(of storyboard: UIStoryboard.Storyboard) -> Self {
        return UIStoryboard(storyboard: storyboard).instantiateViewController()
    }
}

extension UIViewController: StoryboardInstantiable { }
