//
//  GrowtSetupAnswersViewController.swift
//  Created by Pasha P.
//

import UIKit

class GrowtSetupAnswersViewController: UIViewController {

    @IBOutlet weak var navigationBar: RHYTNavigationBar!
    @IBOutlet weak var tableView_PN : UITableView!
    @IBOutlet weak var lblExample : UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var polarChartParentView: UIView!
    @IBOutlet weak var pNTableViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var clayCommentLabel: UILabel!
    @IBOutlet var doConstraints: [NSLayoutConstraint]!
    @IBOutlet var willConstraints: [NSLayoutConstraint]!
    
    let posXXXComment = "Test Message."
    let negXXXComment = "Test Message."
    
    var polarChart: PolarChart?
    var ido = false
    var isPositive = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateForm()
        if ido {
            self.updatePolarChart()
        }
        prepeareData()
        updatePlusButtonVisibility()
        tableView_PN.reloadData()
    }
    
    //MARK: - Setup
    
    func setup() {
        setupNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("6_Goal_Setting_Will_Do_Wont_Do"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("7_Goal_Setting_Target_Practice"), object: nil)
        self.tableView_PN.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func setupNavigationBar() {
        
        navigationBar.leftButtonTappedHandler = {[weak self] in
            self?.backViewController()
        }
        navigationBar.rightButtonTappedHandler = {[weak self] in
            if self != nil {
                self!.playVideoOnBtnRequest(vedioNo: "5_Goal_Setting_Dont_Want", viewController: self!)
            }
        }
        navigationBar.subtitle = Date().getDateStringWithEEEEdMMMyyyy()
    }
    
    func updateForm() {
        for constraint in doConstraints {
            constraint.priority = ido ? .defaultHigh : .defaultLow
        }
        for constraint in willConstraints {
            constraint.priority = ido ? .defaultLow : .defaultHigh
        }
        polarChartParentView.isHidden = !ido
        commentView.isHidden = ido
        
        clayCommentLabel.text = isPositive ? posClayComment : negClayComment
    }
    
    //MARK: IBActions
    @IBAction func didTapSaveButton(_ sender: Any) {
        if userSetupMGR.isEmptyComment(ido: ido, positive: isPositive) {
            showAlertOnSelf(message: "Test Message")
            return
        }
        
        userSetupMGR.saveComments(category: isPositive ? (ido ? .ido : .iwill) : (ido ? .idont : .iwont))
        appControllerManger.userAnswerDoViewController.isPositive = true
        if ido {
            if isPositive {
                appControllerManger.userAnswerWontViewController.isPositive = false
                appControllerManger.userAnswerWontViewController.ido = false
                
                let videoName = "6_Goal_Setting_Will_Do_Wont_Do"
                if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
                    self.playVideoBy(name: videoName, viewController: self)
                } else {
                    goToViewController(viewController: appControllerManger.userAnswerWontViewController)
                }
                
            } else {
                appControllerManger.userAnswerDoViewController.isPositive = true
                appControllerManger.userAnswerDoViewController.ido = true
                goToViewController(viewController: appControllerManger.userAnswerDoViewController)
            }
        } else {
            if isPositive {
                let videoName = "7_Goal_Setting_Target_Practice"
                if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
                    self.playVideoBy(name: videoName, viewController: self)
                } else {
                    appControllerManger.goalViewController.onlyGoal = false
                    goToViewController(viewController: appControllerManger.goalViewController)
                }
            } else {
                appControllerManger.userAnswerWillViewController.isPositive = true
                appControllerManger.userAnswerWillViewController.ido = false
                goToViewController(viewController: appControllerManger.userAnswerWillViewController)
            }
        }
    }
    
    @IBAction func didTapPlusButton(_ sender: Any) {
        
        if isPositive {
            if ido {
                userSetupMGR.doComments.append("")
            } else {
                userSetupMGR.willComments.append("")
            }
        } else {
            if ido {
                userSetupMGR.doNotComments.append("")
            } else {
                userSetupMGR.willNotComments.append("")
            }
        }
        tableView_PN.reloadData()
        updatePlusButtonVisibility()
    }
    
    //MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView_PN.layer.removeAllAnimations()
        
        let bottomHeight = ScreenSize.SCREEN_HEIGHT - saveButton.frame.origin.y
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        if (tableView_PN.contentSize.height < ScreenSize.SCREEN_HEIGHT - polarChartParentView.frame.height - bottomHeight - 75 - navigationBar.frame.height - bottomPadding) {
            pNTableViewHeightConstraint.constant = tableView_PN.contentSize.height
            UIView.animate(withDuration: 0.5) {
                self.updateViewConstraints()
            }
        }
    }
    
    //MARK: Internal
    func prepeareData() {
        
        let cat:GrowthAnswerCategory = isPositive ? (ido ? .ido : .iwill) : (ido ? .idont : .iwont)
        if !(userSetupMGR.commentsRetrieved[cat] ?? false) {
            userSetupMGR.retrieveComments(category: cat)
        }
        
        if isPositive {
            if ido {
                if userSetupMGR.doComments.count == 0 {
                    userSetupMGR.doComments.append("")
                }
            } else {
                if userSetupMGR.willComments.count == 0 {
                    userSetupMGR.willComments.append("")
                }
            }
        } else {
            if ido {
                if userSetupMGR.doNotComments.count == 0 {
                    userSetupMGR.doNotComments.append("")
                }
            } else {
                if userSetupMGR.willNotComments.count == 0 {
                    userSetupMGR.willNotComments.append("")
                }
            }
        }
        let hints = isPositive ? (ido ? userSetupMGR.doHints : userSetupMGR.willHints) :
                    (ido ? userSetupMGR.doNotHints : userSetupMGR.willNotHints)
        if hints.count == 0 {
            getHints()
        } else {
            updateHints()
        }
    }
    
    func updatePolarChart() {
        
        self.polarChart?.removeFromSuperview()
        let polarChartView = PolarChart(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        var radiusFactors = [Float]()
        for cat in userSetupMGR.wheelCategories {
            radiusFactors.append(Float(cat.grade) * 0.1)
        }
        
        polarChartView.setupAsRhytPolarChart(radiusFactors: radiusFactors, parentView: self.polarChartParentView)
        self.polarChart = polarChartView
    }
    
    func updateHints() {
        let hints = isPositive ? (ido ? userSetupMGR.doHints : userSetupMGR.willHints) :
                    (ido ? userSetupMGR.doNotHints : userSetupMGR.willNotHints)
        if hints.count > 0 {
            var result = ""
            for hint in hints {
                result = result + hint.hint + "\n\n"
            }
            lblExample.text = result
        } else {
            if isPositive {
                if ido {
                    lblExample.text = "Test Message"
                } else {
                    lblExample.text = "Test Message"
                }
            } else {
                if ido {
                    lblExample.text = "Test Message"
                } else {
                    lblExample.text = "Test Message"
                }
            }
            
            
        }
    }
    func updatePlusButtonVisibility() {
        plusButton.isHidden = userSetupMGR.isEmptyComment(ido: ido, positive: isPositive)
    }
    
    //MARK: Notifocation Center
    @objc func videoViewed(notificaiton:Notification) {
        
        if notificaiton.name.rawValue == "6_Goal_Setting_Will_Do_Wont_Do" {
            goToViewController(viewController: appControllerManger.userAnswerWontViewController)
        } else if notificaiton.name.rawValue == "7_Goal_Setting_Target_Practice" {
            appControllerManger.goalViewController.onlyGoal = false
            goToViewController(viewController: appControllerManger.goalViewController)
        }
    }
}


//MARK: - Table View
extension GrowtSetupAnswersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPositive ? (ido ? userSetupMGR.doComments.count : userSetupMGR.willComments.count) :
        (ido ? userSetupMGR.doNotComments.count : userSetupMGR.willNotComments.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "UserAnswerTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserAnswerTableViewCell
        let comments = isPositive ? (ido ? userSetupMGR.doComments : userSetupMGR.willComments) :
                        (ido ? userSetupMGR.doNotComments : userSetupMGR.willNotComments)
        let text = comments[indexPath.row]
        cell.setupWith(text: text, number: indexPath.row + 1, positive: isPositive, iDo: ido, totalAnswers: comments.count)
        cell.textChanged = {[weak self] (newText: String) in
            
            
            var editedText = newText
            let isPositive = self?.isPositive ?? false
            let ido = self?.ido ?? false
            editedText.removeFirst(isPositive ? (ido ? 9 : 6) : (ido ? 12 : 7))
            editedText = editedText.trimmingCharacters(in: .whitespacesAndNewlines)

            if isPositive {
                if ido {
                    userSetupMGR.doComments[indexPath.row] = editedText
                } else {
                    userSetupMGR.willComments[indexPath.row] = editedText
                }
            } else {
                if ido {
                    userSetupMGR.doNotComments[indexPath.row] = editedText
                } else {
                    userSetupMGR.willNotComments[indexPath.row] = editedText
                }
            }
            DispatchQueue.main.async {
                self?.tableView_PN.beginUpdates()
                self?.tableView_PN.endUpdates()
            }
            self?.updatePlusButtonVisibility()
        }
        cell.deleted = {[weak self] in
            let isPositive = self?.isPositive ?? false
            let ido = self?.ido ?? false
            if isPositive {
                if ido {
                    userSetupMGR.doComments.remove(at: indexPath.row)
                } else {
                    userSetupMGR.willComments.remove(at: indexPath.row)
                }
            } else {
                if ido {
                    userSetupMGR.doNotComments.remove(at: indexPath.row)
                } else {
                    userSetupMGR.willNotComments.remove(at: indexPath.row)
                }
            }
            self?.tableView_PN.reloadData()
            self?.updatePlusButtonVisibility()
        }
        
        return cell
        
    }
}

//MARK: - API calling Functions
extension GrowtSetupAnswersViewController {
    
    func getHints() {
        
        let category = isPositive ? (ido ? "ido" : "iwill") : (ido ? "idont" : "iwont")
        let url = "\(URL_CONSTANT.GROWTH_SETUP_ANSWER_HINT)/\(category)"
        self.getRequest(url: url, param: nil) { [weak self] (isSuccess, result, message) in
            let isPositive = self?.isPositive ?? false
            let ido = self?.ido ?? false
            if isSuccess {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    let hints = try JSONDecoder().decode([RHYTGrowthToolSetupHintModel].self, from: jsonData)
                    if isPositive {
                        if ido {
                            userSetupMGR.doHints = hints
                        } else {
                            userSetupMGR.willHints = hints
                        }
                    } else {
                        if ido {
                            userSetupMGR.doNotHints = hints
                        } else {
                            userSetupMGR.willNotHints = hints
                        }
                    }
                }
                catch {
                }
            } else {
                if result == nil {
                    if message != nil {
                        self?.showAlertOnSelf(message: message!)
                    }
                } else {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                        let hints = try JSONDecoder().decode([RHYTGrowthToolSetupHintModel].self, from: jsonData)
                        if isPositive {
                            if ido {
                                userSetupMGR.doHints = hints
                            } else {
                                userSetupMGR.willHints = hints
                            }
                        } else {
                            if ido {
                                userSetupMGR.doNotHints = hints
                            } else {
                                userSetupMGR.willNotHints = hints
                            }
                        }
                    }
                    catch {
                    }
                }
            }
            self?.updateHints()
        }
    }
}
