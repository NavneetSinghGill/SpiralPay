//
//  PersonalDetailsViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 29/03/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class PersonalDetailsViewController: SpiralPayViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var homeAddressTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeAddressTableView.rowHeight = UITableViewAutomaticDimension
//        homeAddressTableView.estimatedRowHeight = 95

        
        let nib = UINib(nibName: "HomeAddressTableViewCell", bundle: nil)
        homeAddressTableView.register(nib, forCellReuseIdentifier: "HomeAddressTableViewCell")
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTouched))
        self.scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func scrollViewTouched(gesture: UIPanGestureRecognizer) {
        self.homeAddressTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        User.shared.restore()
        
        emailLabel.text = User.shared.email
        mobileLabel.text = User.shared.phoneWithCode
        nameTextField.text = "\(User.shared.firstName ?? "") \(User.shared.lastName ?? "")"
        reloadTableViewDataWith(animation: false)
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
    
    private func reloadTableViewDataWith(animation: Bool) {
        self.homeAddressTableView.reloadData()
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.homeAddressTableView.contentSize.height
            if animation {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func addressTappedWith(index: Int) {
        var newAddresses = Array<Dictionary<String,String>>()
        
        for address in User.shared.addresses! {
            var newAddress = address
            newAddress[User.isDefault] = "false"
            newAddresses.append(newAddress)
        }
        var address = newAddresses[index]
        address[User.isDefault] = "true"
        newAddresses[index] = address
        User.shared.addresses = newAddresses
        
        User.shared.save()
        self.reloadTableViewDataWith(animation: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.homeAddressTableView.reloadData()
    }

}

extension PersonalDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addresses = User.shared.addresses {
            return addresses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddressTableViewCell", for: indexPath) as! HomeAddressTableViewCell
        cell.delegate = self
        cell.index = indexPath.row
        
        if let addresses = User.shared.addresses {
            cell.doUI(address: addresses[indexPath.row])
        }

        return cell
    }
    
}

extension PersonalDetailsViewController: HomeAddressTableViewCellDelegate {
    
    func deleteButtonTappedWith(index: Int) {
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete this address?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if var addresses = User.shared.addresses {
                addresses.remove(at: index)
                User.shared.addresses = addresses
                User.shared.save()
                self.reloadTableViewDataWith(animation: true)
            }
            
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func editButtonTappedWith(index: Int) {
        let homeAddressVC = HomeAddressViewController.create()
        homeAddressVC.indexOfAddressToShow = index
        self.navigationController?.pushViewController(homeAddressVC, animated: true)
    }
    
    func defaultButtonTappedWith(index: Int) {
        addressTappedWith(index: index)
    }
    
}

extension PersonalDetailsViewController: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == firstNameTextField && textField.text != nil && textField.text!.count != 0 {
//            User.shared.firstName = textField.text
//            User.shared.save()
//        }
//        if textField == lastNameTextField && textField.text != nil && textField.text!.count != 0 {
//            User.shared.lastName = textField.text
//            User.shared.save()
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
