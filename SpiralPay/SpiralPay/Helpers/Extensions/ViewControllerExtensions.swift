//
//  ViewControllerExtensions.swift
//  SpiralPay
//
//  Created by Zoeb on 16/12/17.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK:- Back button action
    
    func updateNavigationBar() {
        self.updateNavigationBarColor()
        self.updateBackButton()
    }
    
    func updateNavigationBarColor() {
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func updateBackButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "back_arrow"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func backButtonTapped() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    // MARK: NavigationBar with left side title
    func navigationBarWithLeftSideTitle(isTitle: Bool, titleName: String) {
        self.updateNavigationBarColor()
        let titleWithSpace = "  \(titleName)  "
        updateBackButtonWithTitle(isLeftTitle: isTitle, leftSideTitle: titleWithSpace)
        
    }
    func updateBackButtonWithTitle(isLeftTitle: Bool, leftSideTitle: String){
        if isLeftTitle {
            self.navigationController?.navigationItem.hidesBackButton = true
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.backgroundColor = .clear
            button.setTitle(leftSideTitle, for: .normal)
            button.titleLabel?.font = UIFont(name: "Helvetica", size: 24)!
            let backBarButton = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = backBarButton
            
            let menuImage    = UIImage(named: "options")!
            let shareTVImage  = UIImage(named: "share")!
            
            let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector (didTapMenuButton))
            let shareButton = UIBarButtonItem(image: shareTVImage, style: .plain, target: self, action: #selector (didTapShareButton))
            menuButton.tintColor = UIColor.white
            shareButton.tintColor = UIColor.white
            navigationItem.rightBarButtonItems = [menuButton, shareButton]
        }
        else{
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.backgroundColor = .clear
            button.setImage(UIImage(named: LocaleKeys.kBackButton.localize()), for: .normal)
            button.setTitle(leftSideTitle, for: .normal)
            button.titleLabel?.font = UIFont(name: "Helvetica", size: 24)!
            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let backBarButton = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }
    
    @objc func didTapMenuButton(){
        print("Menu Button Tapped")
    }
    
    @objc func didTapShareButton(){
        print("Share TV Button Tapped")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
