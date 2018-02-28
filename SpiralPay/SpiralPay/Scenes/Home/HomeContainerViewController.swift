//
//  HomeContainerViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 20/02/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class HomeContainerViewController: UIViewController {
    
    var selectedVC: UIViewController? = nil
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBarCustomView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var tabBarItemViews: [TabBarItemView]!
    
    private lazy var loyaltyViewController: LoyaltyViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "LoyaltyViewController") as! LoyaltyViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var homeViewController: HomeViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var mySpiralPayViewController: MySpiralPayViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MySpiralPayViewController") as! MySpiralPayViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var settingsViewController: SettingsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectItemWith(tag: 102)
        showScreen(newScreen: homeViewController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        shadowView.dropShadow()
//        tabBarCustomView.dropShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabButtonTapped(button: UIButton) {
        return ()
        resetUIAllTabs()
        selectItemWith(tag: button.tag)
        switch button.tag {
        case 101:
            showScreen(newScreen: loyaltyViewController)
        case 102:
            showScreen(newScreen: homeViewController)
        case 103:
            showScreen(newScreen: mySpiralPayViewController)
        case 104:
            showScreen(newScreen: settingsViewController)
        default:
            break
        }
    }
    
    @IBAction func payButtonTapped() {
        let scannerVC = ScannerViewController.create()
        scannerVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(scannerVC, animated: true, completion: nil)
    }
    
    //MARK:- Private methods
    
    private func resetUIAllTabs() {
        for tabBarItemView in tabBarItemViews {
            tabBarItemView.isSelected = false
        }
    }
    
    private func selectItemWith(tag: Int) {
        for tabBarItemView in tabBarItemViews {
            if tabBarItemView.tag == tag {
                tabBarItemView.isSelected = true
                break
            }
        }
    }
    
    //MARK:- Custom Tab bar/ Container view methods
    
    func showScreen(newScreen: UIViewController) {
        if selectedVC != nil {
            remove(asChildViewController: selectedVC!)
        }
        selectedVC = newScreen
        add(asChildViewController: newScreen)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
}
