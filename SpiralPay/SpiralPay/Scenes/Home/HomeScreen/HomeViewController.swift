//
//  HomeViewController.swift
//  SpiralPay
//
//  Created by Zoeb on 22/02/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeDisplayLogic: class
{
    func getPaymentHistorySuccessWith(response: [Home.PaymentHistory.Response])
    func getPaymentHistoryFailureWith(response: Home.PaymentHistory.Response)
    
    func getPaymentDetailSuccessWith(response: Home.PaymentDetail.Response, payment: Home.PaymentHistory.Response)
    func getPaymentDetailFailureWith(response: Home.PaymentDetail.Response, payment: Home.PaymentHistory.Response)
}

enum DurationType {
    case Week
    case Month
}

class HomeViewController: SpiralPayViewController, HomeDisplayLogic
{
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addCartIcon(parentView: scrollViewContainerChildView)
        
        paymentTableView.estimatedRowHeight = 0
        paymentTableView.estimatedSectionHeaderHeight = 0
        paymentTableView.estimatedSectionFooterHeight = 0
        
        getPaymentHistory()
        
        let nib = UINib(nibName: "PaymentHistoryTableViewCell", bundle: nil)
        paymentTableView.register(nib, forCellReuseIdentifier: "PaymentHistoryTableViewCell")
        
        amountLabelTopConstraintDefaultValue = amountLabelTopConstraint.constant
        
        paymentTableView.estimatedRowHeight = 60
        paymentTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.paymentTableView.reloadData()
        
        if shouldRefreshOnNextAppearance {
            shouldRefreshOnNextAppearance = false
            getPaymentHistory()
        }
    }
    
    //MARK:- Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainerChildView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var customSegmentBlueView: UIView!
    @IBOutlet weak var customSegmentBlueViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var expandedCellIndexPath: IndexPath?
    var amountLabelTopConstraintDefaultValue: CGFloat = 0
    
    var shapeL: CAShapeLayer?
    var dotsL: CAShapeLayer?
    
    var payments = [[Home.PaymentHistory.Response]]()
    var maxAmount: CGFloat = 0
    var durationType: DurationType = .Week
    
    var shouldRefreshOnNextAppearance = false
    
    let daysToCoverForWeek = 6
    let daysToCoverForMonth = 29
    
    //MARK:- APIs
    
    func getPaymentHistory() {
        noDataLabel.isHidden = true
        NLoader.shared.startNLoader()
        var request = Home.PaymentHistory.Request()
        
        var dayComp = DateComponents()
        if durationType == .Week {
            dayComp.day = -daysToCoverForWeek
        } else {
            dayComp.day = -daysToCoverForMonth
        }
        let date = Calendar.current.date(byAdding: dayComp, to: Date())!
        
        request.from = "\( Int64(date.timeIntervalSince1970 * 1000) )"
        interactor?.getPaymentHistory(request: request)
    }
    
    func getPaymentHistorySuccessWith(response: [Home.PaymentHistory.Response]) {
        NLoader.shared.stopNLoader()
        
        if response.count == 0 {
            noDataLabel.isHidden = false
        }
        read(response: response)
        
        reloadPaymentTableViewData()
    }
    
    func getPaymentHistoryFailureWith(response: Home.PaymentHistory.Response) {
        NLoader.shared.stopNLoader()
        payments = []
        clearGraph()
        reloadPaymentTableViewData()
        amountLabel.text = "0.00"
        currencyLabel.text = ""
    }
    
    func read(response: [Home.PaymentHistory.Response]) {
        
        var previousDateString = ".."
        payments = []
        var totalAmount: CGFloat = 0
        
        var count = 0
        var dayWiseMaxAmount: CGFloat = 0
        maxAmount = 0
        for payment in response {
            let paymentDateString = self.getFormatterStringWith(timeInterval: payment.created)
            
            if paymentDateString == previousDateString {
                payments[payments.count - 1].append(response[count])
                dayWiseMaxAmount = dayWiseMaxAmount + CGFloat(response[count].amount ?? 0)
            } else {
                payments.append([response[count]])
                previousDateString = paymentDateString
                
                dayWiseMaxAmount = CGFloat(response[count].amount ?? 0)
            }
            
            if maxAmount < dayWiseMaxAmount {
                maxAmount = dayWiseMaxAmount
            }
            
            totalAmount = totalAmount + (payment.amount ?? 0)
            count = count + 1
        }
        
        if let payment = response.first {
            currencyLabel.text = Utils.shared.getCurrencyStringWith(currency: payment.currency)
        } else {
            currencyLabel.text = ""
        }
        
        amountLabel.text = "\(totalAmount/100)"
        
        self.reloadPaymentTableViewData()
        
        //Club the same day payments and create a single object
        var singlePaymentPerDayPayments = [Home.PaymentHistory.Response]()
        
        for singleDayPayments in payments {
            var amountAndCreatedDayPayment = Home.PaymentHistory.Response()
            amountAndCreatedDayPayment.amount = 0
            amountAndCreatedDayPayment.created = 0
            for payment in singleDayPayments {
                amountAndCreatedDayPayment.amount = (amountAndCreatedDayPayment.amount ?? 0) + (payment.amount ?? 0)
            }
            
            if singleDayPayments.count != 0 {
                let newDate = removeAllSmallerTimeOf(dateInterval: ((singleDayPayments.last!.created ?? 0)/1000))
                amountAndCreatedDayPayment.created = Int64(newDate.timeIntervalSince1970) * 1000
            }
            
            singlePaymentPerDayPayments.append(amountAndCreatedDayPayment)
        }
        
        var allPayments = [Home.PaymentHistory.Response]()
        let latestDate = removeAllSmallerTimeOf(dateInterval: Int64(Date().timeIntervalSince1970))
        var limit = 0
        if durationType == .Week {
            limit = 7
        } else {
            limit = 30
        }
        for count in 0...(limit-1) {
            let newDate = getNewDateWith(dateInterval: Int64(latestDate.timeIntervalSince1970 * 1000), decreatedBy: count)
            
            var didMatchAnyPayment = false
            for payment in singlePaymentPerDayPayments {
                if getFormatterStringWith(timeInterval: payment.created) == getFormatterStringWith(timeInterval: Int64(newDate.timeIntervalSince1970 * 1000)) {
                    allPayments.append(payment)
                    didMatchAnyPayment = true
                    break
                }
            }
            
            if !didMatchAnyPayment {
                var newAmountAndCreatedDayPayment = Home.PaymentHistory.Response()
                newAmountAndCreatedDayPayment.amount = 0
                newAmountAndCreatedDayPayment.created = Int64(newDate.timeIntervalSince1970) * 1000
                
                allPayments.append(newAmountAndCreatedDayPayment)
            }
        }
        
        drawGraphWith(payments1Darray: allPayments)
    }
    
    func getPaymentDetailSuccessWith(response: Home.PaymentDetail.Response, payment: Home.PaymentHistory.Response) {
        NLoader.shared.stopNLoader()
        var tempPayment: Home.PaymentHistory.Response?
        
        var column: Int?
        var row: Int?
        
        for singleDayPaymentsCount in 0..<payments.count {
            let singleDayPayments = payments[singleDayPaymentsCount]
            
            for singlePaymentCount in 0..<singleDayPayments.count {
                let singlePayment = singleDayPayments[singlePaymentCount]
                if singlePayment.paymentId == payment.paymentId {
                    column = singleDayPaymentsCount
                    row = singlePaymentCount
                    tempPayment = singlePayment
                    break
                }
            }
        }
        if tempPayment != nil {
            tempPayment!.details = response
            payments[column!][row!] = tempPayment!
        }
        
        if expandedCellIndexPath != nil, let cell = paymentTableView.cellForRow(at: expandedCellIndexPath!) as?  PaymentHistoryTableViewCell {

            cell.shouldExpand = true
            if amountLabelTopConstraint.constant == amountLabelTopConstraintDefaultValue {
                amountLabelTopConstraint.constant = amountLabelTopConstraintDefaultValue - paymentTableView.frame.origin.y
            }
            backButton.isHidden = false
            cartView?.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            self.reloadPaymentTableViewData()
            
            //Fixes the issue of tableview getting cut off on expansion
            var fr = paymentTableView.frame
            fr.size.height = 1
            scrollView.scrollRectToVisible(fr, animated: true)
        }
    }
    
    func getPaymentDetailFailureWith(response: Home.PaymentDetail.Response, payment: Home.PaymentHistory.Response) {
        NLoader.shared.stopNLoader()
        
        expandedCellIndexPath = nil
        amountLabelTopConstraint.constant = amountLabelTopConstraintDefaultValue
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        self.reloadPaymentTableViewData()
    }
    
    //MARK:- Private methods
    
    private func reloadPaymentTableViewData() {
        paymentTableView.reloadData()
        if (expandedCellIndexPath != nil) {
            self.paymentTableViewHeightConstraint.constant = self.view.frame.size.height
            self.scrollView.isScrollEnabled = false
        } else {
            self.paymentTableViewHeightConstraint.constant = self.paymentTableView.contentSize.height
            self.scrollView.isScrollEnabled = true
        }
        self.view.layoutIfNeeded()
        if expandedCellIndexPath != nil {
            paymentTableView.scrollToRow(at: expandedCellIndexPath!, at: .top, animated: true)
        }
    }
    
    private func drawGraphWith(payments1Darray: [Home.PaymentHistory.Response]) {
        clearGraph()
        var points = Array<CGPoint>()
        let currentDate = self.removeAllSmallerTimeOf(date: Date())
        var dayComp = DateComponents()
        
        for payment in payments1Darray {
            let xValue = getPointFor(dateInterval: Int64(timeIntervalAfterRemovingAllSmallerTimeOf(dateInterval: payment.created ?? 0)),
                                     currentDate: currentDate,
                                     dateComponent: &dayComp)
            let yValue = getPointFor(amount: payment.amount ?? 0)
            
            points.append(CGPoint(x: xValue, y: yValue))
        }
        
//        addLineGraphWith(points: points)
        var traversedPoints = [CGPoint]()
        var count = 0
        for point in points {
            if point ==  points.first {
                traversedPoints.append(point)
                count = count + 1
                continue
            }
            if point == points.last {
                traversedPoints.append(point)
                addLineGraphWith(points: traversedPoints)
                count = count + 1
                continue
            }
            if (points[count - 1].y == self.graphView.frame.size.height &&
                points[count + 1].y != self.graphView.frame.size.height) ||
                (points[count - 1].y != self.graphView.frame.size.height &&
                    points[count + 1].y == self.graphView.frame.size.height) {
                if points[count].y == self.graphView.frame.size.height {
                    //Self y = 0
                    traversedPoints.append(point)
                    addLineGraphWith(points: traversedPoints)
                    
                    traversedPoints.removeAll()
                    traversedPoints.append(point)
                } else {
                    traversedPoints.append(point)
                }
            } else {
                traversedPoints.append(point)
            }
            count = count + 1
        }
        if let firstPoint = points.first {
            addDotsTo(points: [firstPoint])
        }
    }
    
    private func getNewDateWith(dateInterval: Int64, decreatedBy daysCount: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = -daysCount
        let decreasedDate = Calendar.current.date(byAdding: dateComponent, to: Date(timeIntervalSince1970: TimeInterval(dateInterval)/1000))!
        
        return decreasedDate
    }
    
    private func getPointFor(dateInterval: Int64, currentDate: Date, dateComponent: inout DateComponents) -> CGFloat {
        
        var startingDate: Date?
        if durationType == .Week {
            dateComponent.day = -daysToCoverForWeek
            dateComponent.month = 0
            startingDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        } else {
            dateComponent.day = -daysToCoverForMonth
            dateComponent.month = 0
            startingDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        }
        let startingDateInterval = CGFloat(startingDate!.timeIntervalSince1970)
        let currentDateInterval = CGFloat(currentDate.timeIntervalSince1970)
        
        let percentage = ((CGFloat(dateInterval)/1000 - startingDateInterval) / (currentDateInterval - startingDateInterval))
        return percentage * graphView.frame.size.width
    }
    
    private func getPointFor(amount: CGFloat) -> CGFloat {
        // substracted from 1 to reverse Y axis
        let percentage = 1 - (amount / CGFloat(maxAmount == 0 ? 1 : maxAmount))
        return percentage * graphView.frame.size.height
    }
    
    private func clearGraph() {
        if let sublayers = graphView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    private func addLineGraphWith(points: [CGPoint]) {
        let aPath = UIBezierPath.interpolateCGPointsWithHermite(pointsAsNSValues: points as Array<AnyObject>, closed: false)
        
        if aPath != nil {
            shapeL = CAShapeLayer()
            shapeL!.path = aPath!.cgPath
            shapeL!.fillColor = UIColor.clear.cgColor
            shapeL!.strokeColor = Colors.pink.cgColor
            shapeL!.lineWidth = 1
            
            shapeL!.masksToBounds = false
            shapeL!.shadowColor = UIColor.black.cgColor
            shapeL!.shadowOpacity = 0.3
            shapeL!.shadowOffset = CGSize(width: 0, height: 2)
            shapeL!.shadowRadius = 0
            shapeL!.shouldRasterize = true
            
            graphView.layer.addSublayer(shapeL!)
        }
    }
    
    private func addDotsTo(points: [CGPoint]) {
        dotsL = CAShapeLayer()
        for point in points {
            let greyDot = CAShapeLayer()
            
            let greyDotPath = UIBezierPath(arcCenter: point,
                                           radius: 8,
                                           startAngle: 0,
                                           endAngle: 6*CGFloat.pi,
                                           clockwise: true)
            greyDot.path = greyDotPath.cgPath
            greyDot.fillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.9).cgColor
            
            greyDot.masksToBounds = false
            greyDot.shadowColor = UIColor.black.cgColor
            greyDot.shadowOpacity = 0.2
            greyDot.shadowOffset = CGSize(width: 0, height: 2)
            greyDot.shadowRadius = 2
            greyDot.shouldRasterize = true
            
            dotsL?.addSublayer(greyDot)
            
            let dot = CAShapeLayer()
            
            let pinkDotPath = UIBezierPath(arcCenter: point,
                                           radius: 4,
                                           startAngle: 0,
                                           endAngle: 6*CGFloat.pi,
                                           clockwise: true)
            dot.path = pinkDotPath.cgPath
            dot.fillColor = Colors.pink.cgColor
            dotsL?.addSublayer(dot)
        }
        
        graphView.layer.addSublayer(dotsL!)
    }
    
    private func removeAllSmallerTimeOf(dateInterval: Int64) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(dateInterval))
        
        let newDate = Calendar.current.date(byAdding: getDateComponentWithNoSmallTimeValuesFrom(date: date), to: date)
        return newDate!
    }
    
    private func removeAllSmallerTimeOf(date: Date) -> Date {
        let newDate = Calendar.current.date(byAdding: getDateComponentWithNoSmallTimeValuesFrom(date: date), to: date)
        return newDate!
    }
    
    private func timeIntervalAfterRemovingAllSmallerTimeOf(dateInterval: Int64) -> TimeInterval {
        let date = Date(timeIntervalSince1970: TimeInterval(dateInterval))
        
        let newDate = Calendar.current.date(byAdding: getDateComponentWithNoSmallTimeValuesFrom(date: date), to: date)
        return newDate!.timeIntervalSince1970
    }
    
    private func getDateComponentWithNoSmallTimeValuesFrom(date: Date) -> DateComponents {
        var dateComponent = DateComponents()
        dateComponent.nanosecond = -date.nanosecond
        dateComponent.second = -date.second
        dateComponent.minute = -date.minute
        dateComponent.hour = -date.hour //12 to increase by half day
        
        return dateComponent
    }
    
    private func getFormatterStringWith(timeInterval: Int64?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM"
        
        let paymentDate = Date(timeIntervalSince1970: Double(timeInterval ?? 0)/1000)
        let paymentDateString = dateFormatter.string(from: paymentDate)
        
        return paymentDateString
    }
    
    //MARK:- IBAction methods
    
    @IBAction func thisWeekButtonTapped() {
        customSegmentBlueViewTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        UIView.transition(with: weekButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.weekButton.setTitleColor(.white, for: .normal)
        },
                          completion: nil)
        
        UIView.transition(with: monthButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.monthButton.setTitleColor(UIColor(white: 130/255, alpha: 1), for: .normal)
        },
                          completion: nil)
        
        durationType = .Week
        getPaymentHistory()
    }
    
    @IBAction func thisMonthButtonTapped() {
        customSegmentBlueViewTrailingConstraint.constant = customSegmentBlueView.frame.size.width
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        UIView.transition(with: weekButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.weekButton.setTitleColor(UIColor(white: 130/255, alpha: 1), for: .normal)
        },
                          completion: nil)
        
        UIView.transition(with: monthButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.monthButton.setTitleColor(.white, for: .normal)
        },
                          completion: nil)
        
        durationType = .Month
        getPaymentHistory()
    }
    
    @IBAction func backButtonTapped() {
        expandedCellIndexPath = nil
        amountLabelTopConstraint.constant = amountLabelTopConstraintDefaultValue
        backButton.isHidden = true
        cartView?.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        //Because of this reload the old data is refreshed and if apip is called then the new cell is refrshed on getting api response
        self.reloadPaymentTableViewData()
    }
    
    private func getPaymentDetailFor(payment: Home.PaymentHistory.Response) {
        NLoader.shared.startNLoader()
        var request = Home.PaymentDetail.Request()
        request.paymentID = payment.paymentId
        
        interactor?.getPaymentDetails(request: request,
                                      payment: payment)
    }
    
    //MARK:- Overridden methods
    
    override func cartButtonTapped() {
        if badge == 0 {
            return
        }
        
        let cartScreen = ShoppingCartViewController.create()
        if self.navigationController != nil {
            self.parent?.navigationController?.pushViewController(cartScreen, animated: true)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Sections are added cells in rows only to avoid complications
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments[section].count + 1 //1 is for section cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHeaderCell", for: indexPath)
            
            guard let label1 = cell.viewWithTag(101) as? UILabel else {
                return cell
            }
            
            guard let label2 = cell.viewWithTag(102) as? UILabel else {
                return cell
            }
            
            let created = payments[indexPath.section][indexPath.row].created
            label1.text = self.getFormatterStringWith(timeInterval: created)
            label2.text = self.getFormatterStringWith(timeInterval: created)
            
            if expandedCellIndexPath != nil {
                label1.isHidden = true
                label2.isHidden = false
            } else {
                label1.isHidden = false
                label2.isHidden = true
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryTableViewCell", for: indexPath) as! PaymentHistoryTableViewCell
            let payment = payments[indexPath.section][indexPath.row - 1] // 1 substract as section is 1st always
            cell.payment = payment
            
            cell.merchantNameLabel.text = payment.merchantName
            Utils.shared.downloadImageFrom(url: Utils.shared.getURLfor(id: payment.merchantLogoId), for: cell.merchantImageView)

            cell.amountLabel.text = Utils.shared.getFormattedAmountStringWith(currency: payment.currency, amount: CGFloat(payment.amount ?? 0))
            
            if expandedCellIndexPath == indexPath {
                cell.shouldExpand = true
            } else {
                cell.shouldExpand = false
            }
            
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 60
//        } else {
//            if let cell = tableView.cellForRow(at: indexPath) as?  PaymentHistoryTableViewCell {
//                cell.reloadTableView()
//                return cell.detailsTableView.frame.origin.y + cell.detailsTableViewHeightConstraint.constant
//            }
//            return 55
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as?  PaymentHistoryTableViewCell {
            //This indexpath will be used after api response
            var indexPathToSetAfterEverything: IndexPath? = nil
            
            if expandedCellIndexPath == nil {
                if cell.payment != nil {
                    indexPathToSetAfterEverything = indexPath
                    getPaymentDetailFor(payment: cell.payment!)
                }
            } else if expandedCellIndexPath != indexPath {
                if let previousCell = tableView.cellForRow(at: expandedCellIndexPath!) as? PaymentHistoryTableViewCell {
                    previousCell.shouldExpand = false
                }

                if cell.payment != nil {
                    indexPathToSetAfterEverything = indexPath
                    getPaymentDetailFor(payment: cell.payment!)
                }
            } else if expandedCellIndexPath == indexPath {
                expandedCellIndexPath = nil
                amountLabelTopConstraint.constant = amountLabelTopConstraintDefaultValue
                backButton.isHidden = true
                cartView?.isHidden = false
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            //Because of this reload the old data is refreshed and if apip is called then the new cell is refrshed on getting api response
            self.reloadPaymentTableViewData()
            
            expandedCellIndexPath = indexPathToSetAfterEverything
        }
    }
    
}
