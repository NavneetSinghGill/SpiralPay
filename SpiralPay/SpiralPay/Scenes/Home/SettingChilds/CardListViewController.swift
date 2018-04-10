//
//  CardListViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 10/04/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class CardListViewController: SpiralPayViewController {
    
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var cardTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addCardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "AddCardTableViewCell", bundle: nil)
        cardTableView.register(nib, forCellReuseIdentifier: "AddCardTableViewCell")
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTouched))
        self.cardTableView.addGestureRecognizer(tapGesture)
        
        addCardButton.isSelected = true
    }
    
    @objc func tableViewTouched(gesture: UIPanGestureRecognizer) {
        self.cardTableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Card.shared.restore()
        
        reloadTableViewDataWith(animation: false)
    }
    
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openCardAddEditScreen() {
        DispatchQueue.main.async {
            let cardScreen = AddCardManuallyViewController.create()
            cardScreen.screenMode = .AddNew
            cardScreen.appFlowType = .Setting
            self.navigationController?.pushViewController(cardScreen, animated: true)
        }
    }
    
    //MARK:- Private methods
    
    private func reloadTableViewDataWith(animation: Bool) {
        self.cardTableView.reloadData()
        DispatchQueue.main.async {
            var height = self.cardTableView.contentSize.height
            self.cardTableView.isScrollEnabled = false
            
            if (self.cardTableView.contentSize.height + self.cardTableView.frame.origin.y + self.addCardButton.frame.height + 40) > self.view.frame.size.height {
                
                height = self.view.frame.size.height - (self.cardTableView.frame.origin.y + self.addCardButton.frame.height + 40)
                self.cardTableView.isScrollEnabled = true
            }
            self.cardTableViewHeightConstraint.constant = height
            if animation {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                self.view.layoutIfNeeded()
            }
        }
    }

}

extension CardListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cards = Card.shared.cards {
            return cards.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCardTableViewCell", for: indexPath) as! AddCardTableViewCell
        cell.delegate = self
        cell.index = indexPath.row
        
        if let cards = Card.shared.cards {
            cell.doUI(card: cards[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func cardTappedWith(index: Int) {
        var newCards = Array<Dictionary<String,String>>()
        
        for card in Card.shared.cards! {
            var newCard = card
            newCard[Card.isDefault] = "false"
            newCards.append(newCard)
        }
        var card = newCards[index]
        card[Card.isDefault] = "true"
        newCards[index] = card
        Card.shared.cards = newCards
        
        Card.shared.save()
        self.reloadTableViewDataWith(animation: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cardTableView.reloadData()
    }
    
}

extension CardListViewController: AddCardTableViewCellDelegate {
    
    func deleteButtonTappedWith(index: Int) {
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete this card?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if var cards = Card.shared.cards {
                cards.remove(at: index)
                Card.shared.cards = cards
                Card.shared.save()
                self.reloadTableViewDataWith(animation: true)
            }
            
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func editButtonTappedWith(index: Int) {
        let cardScreen = AddCardManuallyViewController.create()
        cardScreen.indexOfCardToShow = index
        cardScreen.screenMode = .Edit
        cardScreen.appFlowType = .Setting
        self.navigationController?.pushViewController(cardScreen, animated: true)
    }
    
    func defaultButtonTappedWith(index: Int) {
        cardTappedWith(index: index)
    }
    
}


