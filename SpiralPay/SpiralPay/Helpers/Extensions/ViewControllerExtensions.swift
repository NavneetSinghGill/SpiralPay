//
//  ViewControllerExtensions.swift
//  SpiralPay
//
//  Created by Zoeb on 16/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationTitle(title:String) {
        let titleLabelTag = 9001
        var navigationTitleLabel: UILabel
        if let navTitleLabel = navigationItem.titleView?.viewWithTag(titleLabelTag) as? UILabel {
            navigationTitleLabel = navTitleLabel
        } else {
            navigationTitleLabel = UILabel()
        }
        navigationTitleLabel.textColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        navigationTitleLabel.font = UIFont(name: "Lato", size: 16)
        navigationTitleLabel.text = title
        navigationTitleLabel.sizeToFit()
        
        navigationItem.titleView = navigationTitleLabel
        removeNavigationBarShadow()
    }
    
    func removeNavigationBarShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
