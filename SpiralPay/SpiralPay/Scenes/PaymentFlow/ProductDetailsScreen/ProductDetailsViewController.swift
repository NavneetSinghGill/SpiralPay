//
//  ProductDetailsViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 12/03/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData

enum DetailsType {
    case Payment
    case Campaign
    case Multiple //Means Basket
}

enum ShutterAction {
    case Open
    case Close
    case Reverse
}

protocol ProductDetailsDisplayLogic: class
{
    func processPaymentSuccessWith(response: ProductDetails.ProcessPayment.Response)
    func processPaymentFailureWith(response: ProductDetails.ProcessPayment.Response)
    
    func createPaymentSuccessWith(response: ProductDetails.CreatePayment.Response)
    func createPaymentFailureWith(response: ProductDetails.CreatePayment.Response)
    
    func getCardTokenSuccessWith(response: ProductDetails.CardToken.Response)
    func getCardTokenFailureWith(response: ProductDetails.CardToken.Response)
    
    func getPaymentDetailSuccessWith(response: Home.PaymentDetail.Response)
    func getPaymentDetailFailureWith(response: Home.PaymentDetail.Response)
    
    func postAddItemToBasketSuccessWith(response: ProductDetails.ItemAddedToBasket.Response, completionBlock: () -> ())
    func postAddItemToBasketFailureWith(response: ProductDetails.ItemAddedToBasket.Response)
}

class ProductDetailsViewController: SpiralPayViewController, ProductDetailsDisplayLogic
{
    var interactor: ProductDetailsBusinessLogic?
    var router: (NSObjectProtocol & ProductDetailsRoutingLogic & ProductDetailsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ProductDetailsInteractor()
        let presenter = ProductDetailsPresenter()
        let router = ProductDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    //MARK:- Variables
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var chooseCardView: UIView!
    @IBOutlet weak var entensionView1: UIView!
    @IBOutlet weak var entensionView2: UIView!
    @IBOutlet weak var seeMoreView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dottedImageView: UIImageView!
    @IBOutlet weak var visaImageView: UIImageView!
    @IBOutlet weak var masterCardImageView: UIImageView!
    
    @IBOutlet weak var seemoreButton: UIButton!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var last4CardDigitsLabel: UILabel!
    @IBOutlet weak var boldTotalAmountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var addressOrEmailLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    
    @IBOutlet weak var blueViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreViewHeightConstraint: NSLayoutConstraint!
    
    var detailsType: DetailsType?
    
    var defaultTableViewHeight: CGFloat = 0
    var defaultSeeMoreViewHeight: CGFloat = 0
    var currency: String?
    
    var total: CGFloat = 0
    var vatTotal: CGFloat = 0
    
    var paymentDetail: Home.PaymentDetail.Response!
    var campaignDetail: Home.GetCampaigns.Response!
    var items = [Home.PaymentDetail.CustomerItems]()
    var combinedItems: [CombinedItem]?
    
    var campaignPaymentID: String?
    var combinedItemPaymentID: String?
    
    var createdPayments: [ProductDetails.CreatePayment.Request]?
    var indexOfPaymentInProgress: Int = -1
    
    var paymentDetailsTimer : Timer?
    var didGetPaymentDetails: Bool = false { 
        didSet {
            if didGetPaymentDetails {
                self.resetTimer()
            }
        }
    }
    
    var numberOfTimesApiWasFired = 0
    
    //MARK:- View Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- APIs
    
    //MARK: Get card token
    
    func getCardToken() {
        var request = ProductDetails.CardToken.Request()
        request.clientIP = Utils.shared.getWiFiAddress()
        request.locale = "\(Locale.current.languageCode ?? "")-\(Locale.current.regionCode ?? "")"
        var amount : CGFloat = 0
        if detailsType == DetailsType.Payment {
            request.currency = paymentDetail.currency
            request.amount = paymentDetail.amount
            amount = paymentDetail.amount ?? 0
        } else if detailsType == DetailsType.Campaign {
            request.currency = campaignDetail.currency
            request.amount = campaignDetail.amount
            amount = campaignDetail.amount ?? 0
        } else if detailsType == DetailsType.Multiple {
            request.currency = createdPayments![indexOfPaymentInProgress].currency
            request.amount = createdPayments![indexOfPaymentInProgress].amount
            
            if let createdPayments = createdPayments {
                for createdPayment in createdPayments {
                    if let items = createdPayment.items {
                        for item in items {
                            amount = amount + ((item.amount ?? 0) * CGFloat(item.count ?? 0))
                        }
                    }
                }
            }
        }
        if VixVerify.shared.isBuyRestricted() && Int(amount/100) >= 30 {
            NLoader.stopAnimating()
            Utils.showAlertWith(message: "Please verify yourself to do payment of more than £30.", inController: self)
            return
        }
        
        request.userAgent = ""
        request.type = "card"
        request.email = User.shared.email
        
        let defaultCard = Card.shared.defaultCard()
        request.cvv = defaultCard[Card.cvv]
        request.number = (defaultCard[Card.number] ?? "").replacingOccurrences(of: " ", with: "")
        request.name = ".."
        
        let defaultAddress = User.shared.defaultAddress()
        request.line1 = defaultAddress[User.address]
        request.line2 = ""
        request.city = defaultAddress[User.city]
        request.postcode = defaultAddress[User.postcode]
        
        //Check if able to find Country alpha code.
        //If it returns nil then pass the same string as it is
        let code = Utils.shared.getCountryCodeFor(country: defaultAddress[User.country] ?? "") ?? ""
        if code.count != 0 {
            request.country = code
        } else {
            request.country = defaultAddress[User.country]
        }
        
        request.state = ""
        
        let expiry = defaultCard[Card.expiry] ?? ""
        if let range = expiry.range(of: "/") {
            request.expiryMonth = Int(expiry[expiry.startIndex..<range.lowerBound])
            request.expiryYear = Int(expiry[range.upperBound..<expiry.endIndex])
        } else {
            return
        }
        
        interactor?.getCardToken(request: request)
        
        NLoader.shared.startNLoader()
    }
    
    func getCardTokenSuccessWith(response: ProductDetails.CardToken.Response) {
        if response.token != nil {
            NLoader.shared.startNLoader()
            var request = ProductDetails.ProcessPayment.Request()
            if detailsType == DetailsType.Payment {
                request.paymentId = paymentDetail.paymentId
            } else if detailsType == DetailsType.Campaign {
                request.paymentId = campaignPaymentID
            } else if detailsType == DetailsType.Multiple {
                request.paymentId = combinedItemPaymentID
            }
            request.cardToken = response.token
            request.customerEmail = User.shared.email
            request.customerPhone = User.shared.phoneWithCode
            
            interactor?.processPayment(request: request)
        } else {
            NLoader.shared.stopNLoader()
            paymentFailed()
        }
    }
    
    func getCardTokenFailureWith(response: ProductDetails.CardToken.Response) {
        NLoader.shared.stopNLoader()
        paymentFailed()
    }
    
    //MARK: Process payment
    
    func processPaymentSuccessWith(response: ProductDetails.ProcessPayment.Response) {
        doMultiplePaymentDetailsAPI()
    }
    
    func processPaymentFailureWith(response: ProductDetails.ProcessPayment.Response) {
        NLoader.shared.stopNLoader()
        paymentFailed()
    }
    
    //MARK: Get payment details
    
    func getPaymentDetailSuccessWith(response: Home.PaymentDetail.Response) {
        NLoader.shared.stopNLoader()
        
        if !didGetPaymentDetails {
            didGetPaymentDetails = true
            
            if response.status == "PAY_COMPLETED" {
                if detailsType != DetailsType.Multiple {
                    showPaymentSuccessScreenWith(paymentDetail: response)
                    
                    User.shared.addLoyaltyPoints(value: Float(response.amount ?? 0)/100)
                } else if detailsType == DetailsType.Multiple && createdPayments!.count == indexOfPaymentInProgress + 1 {
                    User.shared.addLoyaltyPoints(value: Float(createdPayments![indexOfPaymentInProgress].amount ?? 0)/100)
                    
                    //TODO: Here success is shown of last payment only.. wait for designs
                    showPaymentSuccessScreenWith(paymentDetail: response)
                    Utils.shared.deleteCombinedItemsWith(merchantID: createdPayments![indexOfPaymentInProgress].merchantID)
                } else {
                    User.shared.addLoyaltyPoints(value: Float(createdPayments![indexOfPaymentInProgress].amount ?? 0)/100)
                    
                    Utils.shared.deleteCombinedItemsWith(merchantID: createdPayments![indexOfPaymentInProgress].merchantID)
                    doNextPaymentInCaseOfMultipleMerchants()
                }
            } else if response.status == "PAY_FAILED" {
                showPaymentFailedScreenWith(paymentDetail: response)
            }
        }
    }
    
    func getPaymentDetailFailureWith(response: Home.PaymentDetail.Response) {
        NLoader.shared.stopNLoader()
        
        if !didGetPaymentDetails {
            didGetPaymentDetails = true
            
            showPaymentFailedScreenWith(paymentDetail: paymentDetail)
        }
    }
    
    //MARK: Create payment
    
    func createPayment() {
        if detailsType == DetailsType.Campaign {
            NLoader.shared.startNLoader()
            
            var request = ProductDetails.CreatePayment.Request()
            request.merchantID = campaignDetail.merchantId
            request.description = ""
            request.currency = campaignDetail.currency
            request.amount = campaignDetail.amount
            request.redirectUrl = nil
            request.items = campaignDetail.items
            request.vat = campaignDetail.vat
            
            interactor?.createPayment(request: request)
        }
    }
    
    func createPaymentSuccessWith(response: ProductDetails.CreatePayment.Response) {
        if response.paymentId != nil {
            if detailsType == .Campaign {
                campaignPaymentID = response.paymentId
            } else if detailsType == .Multiple {
                combinedItemPaymentID = response.paymentId
            }
            getCardToken()
        } else {
            NLoader.shared.stopNLoader()
            paymentFailed()
        }
    }
    
    func createPaymentFailureWith(response: ProductDetails.CreatePayment.Response) {
        NLoader.shared.stopNLoader()
        paymentFailed()
    }
    
    func paymentFailed() {
        //Filling paymentDetail object removes the headache of managing another useless campaign/combinedItems object in payment status screen
        if detailsType == DetailsType.Campaign {
            paymentDetail.amount = campaignDetail.amount
            paymentDetail.currency = campaignDetail.currency
            paymentDetail.merchantName = campaignDetail.name
        } else if detailsType == DetailsType.Multiple {
            if paymentDetail == nil {
                //This condition satisfies for:
                //1. Failed to get Card token
                paymentDetail = Home.PaymentDetail.Response()
            }
            paymentDetail.amount = createdPayments![indexOfPaymentInProgress].amount
            paymentDetail.currency = createdPayments![indexOfPaymentInProgress].currency
            //TODO:
//            paymentDetail.merchantName = createdPayments![indexOfPaymentInProgress].name
            paymentDetail.merchantName = ""
        }
        showPaymentFailedScreenWith(paymentDetail: paymentDetail)
    }
    
    //MARK: Add item to basket
    
    func addItemToBasketWith(paymentID: String?, completionBlock: @escaping () -> ()) {
        NLoader.shared.startNLoader()
        
        var request = ProductDetails.ItemAddedToBasket.Request()
        request.paymentId = paymentID
        
        interactor?.postAddItemToBasket(request: request) {
            completionBlock()
        }
    }
    
    func postAddItemToBasketSuccessWith(response: ProductDetails.ItemAddedToBasket.Response, completionBlock: () -> ()) {
        NLoader.shared.stopNLoader()
        completionBlock()
    }
    
    func postAddItemToBasketFailureWith(response: ProductDetails.ItemAddedToBasket.Response) {
        NLoader.shared.stopNLoader()
    }
    
    //MARK:- IBAction methods
    
    @IBAction func chooseCardButtonTapped() {
        doChangesToShutterAsPer(shutterAction: .Close)
        
        blueViewLeadingContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.chooseCardView.superview?.layoutIfNeeded()
        }
        
        scrollView.scrollRectToVisible(entensionView1.frame, animated: true)
    }
    
    @IBAction func viewDetailButtonTapped() {
        blueViewLeadingContraint.constant = chooseCardView.frame.size.width
        UIView.animate(withDuration: 0.3) {
            self.chooseCardView.superview?.layoutIfNeeded()
        }
        
        scrollView.scrollRectToVisible(entensionView2.frame, animated: true)
    }
    
    @IBAction func seeMoreButtonTapped(button: UIButton) {
        doChangesToShutterAsPer()
    }
    
    @IBAction func declineButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonTapped() {
        if detailsType == DetailsType.Payment {
            getCardToken()
        } else if detailsType == DetailsType.Campaign {
            createPayment()
        } else if detailsType == DetailsType.Multiple {
            indexOfPaymentInProgress = -1
            doNextPaymentInCaseOfMultipleMerchants()
        }
    }
    
    @IBAction func locationOrEmailButtonTapped(button: UIButton) {
        if button.tag == 11 {
            button.tag = 12
            button.setImage(UIImage(named: "email"), for: .normal)
            addressOrEmailLabel.text = User.shared.email
        } else {
            button.tag = 11
            button.setImage(UIImage(named: "address"), for: .normal)
            setAddressToLabel()
        }
    }
    
    //MARK:- Private methods
    
    private func initialSetup() {
        if detailsType != DetailsType.Multiple {
            addCartIcon(parentView: self.view)
        } else {
            createPaymentsForCombinedItem()
        }
        
        combinedItems = fetchCombinedItems()
        
        setUIwithProduct()
        
        tableView.estimatedRowHeight = 19
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        defaultTableViewHeight = tableViewHeightConstraint.constant
        defaultSeeMoreViewHeight = seeMoreViewHeightConstraint.constant
        
        reloadTableViewData()
        
        setAddressToLabel()
        let defaultCardDict = Card.shared.defaultCard()
        if let cardNumber = defaultCardDict[Card.number] {
            last4CardDigitsLabel.text = String(cardNumber[cardNumber.index(cardNumber.endIndex, offsetBy: -4)..<cardNumber.endIndex])
        } else {
            last4CardDigitsLabel.text = "----"
        }
        
        let number = Card.shared.defaultCard()[Card.number] ?? ""
        if Utils.shared.isVisa(text: number) {
            visaImageView.isHidden = false
            masterCardImageView.isHidden = true
        } else if Utils.shared.isMasterCard(text: number) {
            visaImageView.isHidden = true
            masterCardImageView.isHidden = false
        } else {
            visaImageView.isHidden = true
            masterCardImageView.isHidden = true
        }
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.cardAndDetailsViewSlided))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.contentView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.cardAndDetailsViewSlided))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.contentView.addGestureRecognizer(swipeLeft)
    }
    
    @objc func cardAndDetailsViewSlided(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                viewDetailButtonTapped()
            case UISwipeGestureRecognizerDirection.right:
                chooseCardButtonTapped()
            default:
                break
            }
        }
    }
    
    private func setUIwithProduct() {
        total = 0
        vatTotal = 0
        if detailsType != DetailsType.Multiple {
            for item in items {
                total = total + ((item.amount ?? 0) * CGFloat(item.count ?? 0))
                vatTotal = vatTotal + ((item.vat ?? 0) * CGFloat(item.count ?? 0))
            }
            
            if let item = items.first {
                currency = Utils.shared.getCurrencyStringWith(currency: item.currency)
            }
        } else {
            if let combinedItems = combinedItems {
                for combinedItem in combinedItems {
                    total = total + (CGFloat(combinedItem.amount) * CGFloat(combinedItem.count))
                    vatTotal = vatTotal + (CGFloat(combinedItem.vat) * CGFloat(combinedItem.count))
                }
                
                if let combinedItem = combinedItems.first {
                    currency = Utils.shared.getCurrencyStringWith(currency: combinedItem.currency)
                }
            }
        }
        
        let totalAmountString = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: total)
        totalAmountLabel.text = totalAmountString
        boldTotalAmountLabel.text = "\(total/100)"
        currencyLabel.text = currency
        switch detailsType! {
        case .Payment:
            merchantNameLabel.text = paymentDetail.merchantName
        case .Campaign:
            merchantNameLabel.text = campaignDetail.name
        case .Multiple:
            merchantNameLabel.text = ""
        }
    }
    
    private func reloadTableViewData() {
        tableView.reloadData()
        tableViewHeightConstraint.constant = defaultTableViewHeight
        self.view.layoutIfNeeded()
        
        refreshSeeMoreUI()
    }
    
    private func refreshSeeMoreUI() {
        if defaultTableViewHeight >= tableView.contentSize.height {
            seeMoreViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        } else {
            seeMoreViewHeightConstraint.constant = defaultSeeMoreViewHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func doChangesToShutterAsPer(shutterAction: ShutterAction = .Reverse) {
        if shutterAction == .Reverse {
            seemoreButton.isSelected = !seemoreButton.isSelected
        } else if shutterAction == .Open {
            seemoreButton.isSelected = true
        } else if shutterAction == .Close {
            seemoreButton.isSelected = false
        }
        
        if seemoreButton.isSelected {
            tableViewHeightConstraint.constant = tableView.contentSize.height
        } else {
            tableViewHeightConstraint.constant = defaultTableViewHeight
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func doMultiplePaymentDetailsAPI() {
        self.numberOfTimesApiWasFired = 0
        paymentDetailsTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            self.numberOfTimesApiWasFired = self.numberOfTimesApiWasFired + 1
            // 5 * 36 = 180 = 3minutes so show failed after that
            if self.numberOfTimesApiWasFired == 37 {
                self.resetTimer()
                self.showPaymentFailedScreenWith(paymentDetail: self.paymentDetail)
            } else {
                self.getPaymentDetails()
            }
        })
    }
    
    func getPaymentDetails() {
        var request = Home.PaymentDetail.Request()
        if detailsType == DetailsType.Payment {
            request.paymentID = paymentDetail.paymentId
        } else if detailsType == DetailsType.Campaign {
            request.paymentID = campaignPaymentID
        } else if detailsType == DetailsType.Multiple {
            request.paymentID = combinedItemPaymentID
        }
        self.interactor?.getPaymentDetails(request: request)
    }
    
    func resetTimer() {
        paymentDetailsTimer?.invalidate()
        paymentDetailsTimer = nil
    }
    
    func showPaymentSuccessScreenWith(paymentDetail: Home.PaymentDetail.Response) {
        let paymentStatusScreen = PaymentStatusViewController.create()
        paymentStatusScreen.paymentDetail = paymentDetail
        paymentStatusScreen.paymentStatus = .Completed
        
        self.navigationController?.pushViewController(paymentStatusScreen, animated: true)
    }
    
    func showPaymentFailedScreenWith(paymentDetail: Home.PaymentDetail.Response) {
        let paymentStatusScreen = PaymentStatusViewController.create()
        paymentStatusScreen.paymentDetail = paymentDetail
        paymentStatusScreen.paymentStatus = .Failed
        
        self.navigationController?.pushViewController(paymentStatusScreen, animated: true)
    }
    
    func createPaymentsForCombinedItem() {
        createdPayments = [ProductDetails.CreatePayment.Request]()
        
        //Find all merchants from CombinedItems data
        var merchantIdDictionaries: Array<AnyObject>?
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CombinedItem")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.propertiesToGroupBy = ["merchantID"]
            fetchRequest.propertiesToFetch = ["merchantID"]
            fetchRequest.resultType = .dictionaryResultType
            merchantIdDictionaries = try ApplicationDelegate.mainContext.fetch(fetchRequest)
        } catch {
            Utils.print(object: ("Fetching combined items Failed"))
            return
        }
        
        if let merchantIdDictionaries = merchantIdDictionaries {
            
            for merchantIdDictionary in merchantIdDictionaries {
                if let merchantIdDictionary = merchantIdDictionary as? Dictionary<String,String>,
                    let merchantID = merchantIdDictionary["merchantID"] {
                    
                    createPaymentAndAddToArrayWith(merchantID: merchantID)
                }
            }
            
        }
        
        
    }
    
    func createPaymentAndAddToArrayWith(merchantID: String) {
        var combinedItemsWithCommonMerchant: [CombinedItem]? = nil
        do {
            let fetchRequest = NSFetchRequest<CombinedItem>(entityName: "CombinedItem")
            fetchRequest.predicate = NSPredicate(format: "merchantID == %@", merchantID)
            combinedItemsWithCommonMerchant = try ApplicationDelegate.mainContext.fetch(fetchRequest)
        } catch {
            Utils.print(object: ("Fetching combined items Failed"))
            return
        }
        
        //Create payment request object with combined items
        if let combinedItem = combinedItemsWithCommonMerchant?.first {
            
            var request = ProductDetails.CreatePayment.Request()
            request.merchantID = combinedItem.merchantID
            request.description = ""
            request.currency = combinedItem.currency
            request.redirectUrl = nil
            
            var vat: CGFloat = 0
            var amount: CGFloat = 0
            var items = Array<Home.PaymentDetail.CustomerItems>()
            for combinedItem in combinedItemsWithCommonMerchant! {
                items.append(Home.PaymentDetail.CustomerItems(combinedItem: combinedItem))
                vat = vat + CGFloat(combinedItem.vat * combinedItem.count)
                amount = amount + CGFloat(combinedItem.amount * combinedItem.count)
            }
            request.items = items
            request.vat = vat
            if isTestEnvironment {
                request.amount = 2099
            } else {
                request.amount = amount
            }
            
            if createdPayments != nil {
                createdPayments!.append(request)
            }
        }
    }
    
    func doNextPaymentInCaseOfMultipleMerchants() {
        indexOfPaymentInProgress = indexOfPaymentInProgress + 1
        
        if let paymentRequest = createdPayments?[indexOfPaymentInProgress] {
            interactor?.createPayment(request: paymentRequest)
        }
    }
    
    func setAddressToLabel() {
        let address = User.shared.defaultAddress()
        addressOrEmailLabel.text = "\(address[User.address] ?? "") \(address[User.city] ?? "") \(address[User.country] ?? "") \(address[User.postcode] ?? "")"
    }
    
    //MARK:- Overridden methods
    
    @objc override func cartButtonTapped() {
        let openCartScreenBlock = {
            DispatchQueue.main.async {
                let cartScreen = ShoppingCartViewController.create()
                if self.navigationController != nil {
                    self.navigationController?.pushViewController(cartScreen, animated: true)
                } else {
                    self.present(cartScreen, animated: true, completion: nil)
                }
            }
        }
        
        
        if detailsType == DetailsType.Payment {
            
            let paymentBlock = {
                let context = ApplicationDelegate.mainContext
                _ = Utils.shared.getPaymentObjectFor(payment: self.paymentDetail, context: context)
                do {
                    try context.save()
                    openCartScreenBlock()
                } catch let nserror as NSError {
                    Utils.print(object: ("\nFailed to save payment details: \(nserror), \(nserror.userInfo)"))
                }
            }
            
            addItemToBasketWith(paymentID: self.paymentDetail.paymentId) {
                //Save data after api is success
                paymentBlock()
            }
            
        } else {
            
            let context = ApplicationDelegate.mainContext
           _ = Utils.shared.getCampaignObjectFor(campaign: campaignDetail, context: context)
            do {
                try context.save()
                openCartScreenBlock()
            } catch let nserror as NSError {
                Utils.print(object: ("\nFailed to save campaign details: \(nserror), \(nserror.userInfo)"))
            }
            
        }
        
    }
    
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if detailsType != .Multiple {
            if items.count == 0 {
                return 0
            } else {
                return items.count + 2
            }
        } else {
            if let combinedItems = combinedItems {
                if combinedItems.count == 0 {
                    return 0
                } else {
                    return combinedItems.count + 2
                }
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if detailsType != .Multiple, indexPath.row < items.count {
            
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            
            guard let itemNameLabel = itemCell.viewWithTag(101) as? UILabel else {
                return itemCell
            }
            guard let itemAmountLabel = itemCell.viewWithTag(102) as? UILabel else {
                return itemCell
            }
            let item = items[indexPath.row]
            itemNameLabel.text = "\(item.count ?? 1)x \(item.name ?? "-")"
            itemAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: item.currency, amount: ((item.amount ?? 0) * CGFloat(item.count ?? 0)))
            
            return itemCell
            
        } else if detailsType == .Multiple, let combinedItems = combinedItems, indexPath.row < combinedItems.count {
            
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            
            guard let itemNameLabel = itemCell.viewWithTag(101) as? UILabel else {
                return itemCell
            }
            guard let itemAmountLabel = itemCell.viewWithTag(102) as? UILabel else {
                return itemCell
            }
            let combinedItem = combinedItems[indexPath.row]
            itemNameLabel.text = "\(combinedItem.count)x \(combinedItem.name ?? "-")"
            itemAmountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: combinedItem.currency, amount: CGFloat(combinedItem.amount) * CGFloat(combinedItem.count))
            
            return itemCell
            
        } else {
            
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath)
            
            guard let headingLabel = itemCell.viewWithTag(101) as? UILabel else {
                return itemCell
            }
            guard let amountLabel = itemCell.viewWithTag(102) as? UILabel else {
                return itemCell
            }
            
            if detailsType != .Multiple {
                if indexPath.row == items.count {
                    headingLabel.text = "Sub total"
                    amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: total - vatTotal)
                } else if indexPath.row == items.count + 1 {
                    headingLabel.text = "VAT paid"
                    amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: vatTotal)
                }
            } else {
                if let combinedItems = combinedItems {
                    if indexPath.row == combinedItems.count {
                        headingLabel.text = "Sub total"
                        amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: total - vatTotal)
                    } else if indexPath.row == combinedItems.count + 1 {
                        headingLabel.text = "VAT paid"
                        amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: currency, amount: vatTotal)
                    }
                }
            }
            
            return itemCell
        }
    }
    
}

