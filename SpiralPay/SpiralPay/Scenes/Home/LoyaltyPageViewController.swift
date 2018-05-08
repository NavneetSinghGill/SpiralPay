//
//  LoyaltyPageViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 08/05/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class LoyaltyPageViewController: UIPageViewController, UIScrollViewDelegate {
    
    fileprivate lazy var pages: [UIViewController] = {
        let activeVC = LoyaltyContentViewController.create()
        activeVC.loyaltyContentType = LoyaltyContentType.Active
        let availableVC = LoyaltyContentViewController.create()
        availableVC.loyaltyContentType = LoyaltyContentType.Available
        let redeemedVC = LoyaltyContentViewController.create()
        redeemedVC.loyaltyContentType = LoyaltyContentType.Redeemed
        
        return [
            activeVC,
            availableVC,
            redeemedVC
        ]
    }()
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for page in pages {
            _ = page.view
        }
        
        self.dataSource = self
        self.delegate   = self
        
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setControllerOf(index: Int) {
        self.setViewControllers([pages[index]], direction: index > currentIndex ? .forward : .reverse, animated: true, completion: nil)
        currentIndex = index
    }
    
}

extension LoyaltyPageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}

extension LoyaltyPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? LoyaltyContentViewController {
                if let loyaltyViewController = parent as? LoyaltyViewController {
                    switch currentViewController.loyaltyContentType {
                    case .Active:
                        currentIndex = 0
                        loyaltyViewController.activeButtonTapped()
                    case .Available:
                        currentIndex = 1
                        loyaltyViewController.availableButtonTapped()
                    case .Redeemed:
                        currentIndex = 2
                        loyaltyViewController.redeemedButtonTapped()
                    }
                }
            }
        }
    }
    
}
