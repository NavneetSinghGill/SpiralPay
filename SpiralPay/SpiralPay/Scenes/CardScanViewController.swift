//
//  CardScanViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 11/06/18.
//  Copyright © 2018 EnvisionWorld. All rights reserved.
//

import UIKit

protocol CardScanDelegate {
    func cardScanSuccessful(cardInfo: CardIOCreditCardInfo!)
}

class CardScanViewController: SpiralPayViewController {
    
    @IBOutlet weak var cardIOView: CardIOView!
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    
    var cardScanDelegate: CardScanDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CardIOUtilities.canReadCardWithCamera() {
            //TODO: Hide your "Scan Card" button, or take other appropriate action...
        } else {
            cardIOView.delegate = self
            cardIOView.guideColor = .white
            cardIOView.hideCardIOLogo = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CardIOUtilities.preloadCardIO()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardViewHeightConstraint.constant = cardIOView.cameraPreviewFrame.size.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- IBAction methods
    
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CardScanViewController: CardIOViewDelegate {
    
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        cardScanDelegate?.cardScanSuccessful(cardInfo: cardInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
}

