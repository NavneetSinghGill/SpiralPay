//
//  PersonalDetailsViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 29/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class PersonalDetailsViewController: SpiralPayViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var homeAddressTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeAddressTableView.rowHeight = UITableViewAutomaticDimension
        homeAddressTableView.estimatedRowHeight = 0
        homeAddressTableView.estimatedSectionHeaderHeight = 0
        homeAddressTableView.estimatedSectionFooterHeight = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        User.shared.restore()
        
        emailLabel.text = User.shared.email
        mobileLabel.text = User.shared.phoneWithCode
        
        let name = User.shared.name ?? ""
        if let first = name.components(separatedBy: " ").first {
            firstNameLabel.text = first
        } else {
            firstNameLabel.text = "-"
        }
        if name.components(separatedBy: " ").count > 1, let last = name.components(separatedBy: " ").last {
            lastNameLabel.text = last
        } else {
            lastNameLabel.text = "-"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadTableViewData()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openSettingsMobileScreen() {
        DispatchQueue.main.async {
            let settingsPhoneScreen = self.storyboard?.instantiateViewController(withIdentifier: "SettingsPhoneViewController") as? PhoneAndEmailViewController
            if let settingsPhoneScreen = settingsPhoneScreen {
                settingsPhoneScreen.screenType = .Setting
                self.navigationController?.pushViewController(settingsPhoneScreen, animated: true)
            }
        }
    }
    
    @IBAction func openChangeEmailScreen() {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(ChangeEmailViewController.create(), animated: true)
        }
    }
    
    @IBAction func openSettingsHomeAddressScreen() {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(HomeAddressViewController.create(), animated: true)
        }
    }
    
    //MARK:- Private methods
    
    private func reloadTableViewData() {
        homeAddressTableView.reloadData()
        tableViewHeightConstraint.constant = homeAddressTableView.contentSize.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

extension PersonalDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddressCellIdentifier", for: indexPath)
        
        guard let addressLabel = cell.viewWithTag(101) as? UILabel else {
            return cell
        }
        
        addressLabel.text = "\(User.shared.address ?? "-")\n\(User.shared.city ?? "-"), \(User.shared.countryName ?? "-")\n\(User.shared.postcode ?? "-")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
