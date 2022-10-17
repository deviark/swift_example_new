//
//  GrowthToolsDashBoardViewController.swift
//  Created by Pasha P.
//

import UIKit

class GrowthToolsDashBoardViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: RHYTNavigationBar!
    
    let collectionArray = [["title":"Self-care","image":#imageLiteral(resourceName: "self_care_selfCare"), "tool": selfCareMGR],
                           ["title":"Journal","image":#imageLiteral(resourceName: "self_care_journal"), "tool": journalMGR],
                           ["title":"10 Things","image":#imageLiteral(resourceName: "self_care_10things"), "tool": tenThingsMGR],
                           ["title":"S.T.A.R.T","image":#imageLiteral(resourceName: "self_care_start"), "tool": startMGR],
                           ["title":"Triggers","image":#imageLiteral(resourceName: "self_care_mastry"), "tool": triggerMGR],
                           ["title":"Focus 5","image":#imageLiteral(resourceName: "self_care_focus"),  "tool": focusFiveMGR]]
    
    @IBOutlet weak var collectionView_growthTool: UICollectionView!
    @IBOutlet weak var setUpView: UIView!
    @IBOutlet weak var setupCancelButton: UIButton!
    @IBOutlet weak var btnRandom: UIButton!
    @IBOutlet weak var btnRandomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var setupButton: UIButton!
    
    var isFirstTime = false
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("4_Goal_Setting_Wheel_of_Life"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("14_Selfcare_Client_Intro"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("8_10_Things_Setup_Video_1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("10_Things-Client_Intro"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("15_Growth_Tools_Journal_Intro_Video"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("11_S_T_A_R_T_Client_Onboarding"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("12_Triggers_Client_Onboarding_Intro"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("18_S_T_A_R_T_Client_Intro"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("19_Triggers_Client_Intro"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoViewed(notificaiton:)), name: Notification.Name("20_Focus_Five_Client_Intro"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        navigationBar.subtitle = Date().getDateStringWithEEEEdMMMyyyy()
        getStatuses()
    }
    
    func setupNavigationBar() {
        
        navigationBar.leftButtonTappedHandler = {[weak self] in
            self?.backViewController()
        }
        navigationBar.rightButtonTappedHandler = {[weak self] in
            if self != nil {
                self?.showAlert(message: noAvailableFeature)
            }
        }
    }
    
    @objc func videoViewed(notificaiton:Notification) {
        if notificaiton.name.rawValue == "4_Goal_Setting_Wheel_of_Life" {
            self.goToViewController(viewController: appControllerManger.wheelOfLifeViewController)
        } else if notificaiton.name.rawValue == "14_Selfcare_Client_Intro" {
            self.goToViewController(viewController: appControllerManger.selfCareEntryViewController)
        } else if notificaiton.name.rawValue == "8_10_Things_Setup_Video_1" {
            self.goToViewController(viewController: appControllerManger.tenThingsSetupNegativeVC)
        } else if notificaiton.name.rawValue == "10_Things-Client_Intro" {
            self.goToViewController(viewController: appControllerManger.tenThingsHighlightViewController)
        } else if notificaiton.name.rawValue == "15_Growth_Tools_Journal_Intro_Video" {
            self.goToViewController(viewController: appControllerManger.journalSelectDateViewController)
        } else if notificaiton.name.rawValue == "11_S_T_A_R_T_Client_Onboarding" {
            self.goToViewController(viewController: appControllerManger.startSetupViewController)
        } else if notificaiton.name.rawValue == "18_S_T_A_R_T_Client_Intro" {
            self.goToViewController(viewController: appControllerManger.startEntryViewController)
        } else if notificaiton.name.rawValue == "12_Triggers_Client_Onboarding_Intro" {
            self.goToViewController(viewController: appControllerManger.triggersSetupNegativeVC)
        } else if notificaiton.name.rawValue == "19_Triggers_Client_Intro" {
            self.goToViewController(viewController: appControllerManger.triggerEntryViewController)
        } else if notificaiton.name.rawValue == "20_Focus_Five_Client_Intro" {
            self.goToViewController(viewController: appControllerManger.focusViewController)
        }
    }
    
    @IBAction func btnPressedAction(_ sender:UIButton){
        
        switch sender.tag {
        case 0: //Menu
            backViewController()
            break
        case 1: //Notification Bell
            break
        case 2: //Random Button
            let goalShouldChange = (statusMGR.growthToolsSetupStatuses?.isGoalShouldChange ?? false)
            if userSetupMGR.goal.isEmpty || goalShouldChange {
                setUpGoal()
            }
            break
        case 3:
            setUpGoal()
            break
        default:
            break
        }
        
    }

    @IBAction func didTapSetupCancelButton(_ sender: Any) {
        updateGoal(change: false, newGoal: nil)
    }
    //======================== SelfCare ========================
    
    func setUpGoal()  {
        if self.setupCancelButton.isHidden {
            let videoName = "4_Goal_Setting_Wheel_of_Life"
            if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
                self.playVideoBy(name: videoName, viewController: self)
            } else {
                self.goToViewController(viewController: appControllerManger.wheelOfLifeViewController)
            }
        } else {
            appControllerManger.goalViewController.onlyGoal = true
            self.goToViewController(viewController: appControllerManger.goalViewController)
        }
    }
    
    func entrySelfCare()  {
        let videoName = "14_Selfcare_Client_Intro"
        selfCareMGR.needToUpdate = true
        appControllerManger.selfCareEntryViewController.prepeareAsViewController()
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.selfCareEntryViewController)
        }
    }
    
    //======================== 10 Things ========================
    
    func setUp10Things() {
        let videoName = "8_10_Things_Setup_Video_1"
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.tenThingsSetupNegativeVC)
        }
    }
    
    func entry10Things() {
        let videoName = "10_Things-Client_Intro"
        tenThingsMGR.needToUpdate = true
        appControllerManger.tenThingsHighlightViewController.prepeareAsViewController()

        let url = videoMGR.getVideoURLBy(name: videoName)
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) && (url != nil && url != "") {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.tenThingsHighlightViewController)
        }
    }
    
    //======================== Journal ========================.
    func entryJournal() {
        journalMGR.needToUpdate = true
        let videoName = "15_Growth_Tools_Journal_Intro_Video"
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.journalSelectDateViewController)
        }
    }
    
    //======================== S. T. A. R. T. ========================
    func setUpStart() {
        let videoName = "11_S_T_A_R_T_Client_Onboarding"
        startMGR.needToUpdate = true
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.startSetupViewController)
        }
    }
    
    func entryStart() {
        let videoName = "18_S_T_A_R_T_Client_Intro"
        startMGR.needToUpdate = true
        appControllerManger.startEntryViewController.prepeareAsViewController()
        
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.startEntryViewController)
        }
        
    }
    
    //======================== Trigger ========================
    
    func setUpTrigger() {
        let videoName = "12_Triggers_Client_Onboarding_Intro"
        appControllerManger.triggersSetupNegativeVC.positive = false
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.triggersSetupNegativeVC)
        }
    }
    
    func entryTrigger() {
        let videoName = "19_Triggers_Client_Intro"
        triggerMGR.needToUpdate = true
        appControllerManger.triggerEntryViewController.prepeareAsViewController()
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.triggerEntryViewController)
        }
    }
    
    //======================== Foucus ========================
    func entryFocus() {
        let videoName = "20_Focus_Five_Client_Intro"
        focusFiveMGR.needToUpdate = true
        appControllerManger.focusViewController.prepeareAsViewController()
        if !videoMGR.isVideoAlreadyPlayed(name: videoName) {
            self.playVideoBy(name: videoName, viewController: self)
        } else {
            self.goToViewController(viewController: appControllerManger.focusViewController)
        }
    }
}

//MARK: - ## CollectionView Delegate and Datasources

extension GrowthToolsDashBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GrothToolCollectionViewCell", for: indexPath) as! GrothToolCollectionViewCell
        let data = self.collectionArray[indexPath.row]
        cell.setData(data: data, index: indexPath.row,isTrue: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            entrySelfCare()
            break
        case 1:
            entryJournal()
            break
        case 2:
            if tenThingsMGR.state == .needSetup {
                setUp10Things()
            } else {
                entry10Things()
            }
            break
        case 3:
            if startMGR.state == .needSetup {
                setUpStart()
            } else {
                entryStart()
            }
            break
        case 4:
            if triggerMGR.state == .needSetup {
                setUpTrigger()
            } else {
                entryTrigger()
            }
            break
        case 5:
            entryFocus()
            break
        default:
            break
        }
        
        
    }
    
}

//MARK: ## API Calling Functions ##
extension GrowthToolsDashBoardViewController {
    
    func getStatuses() {
        let getStatusGroup = DispatchGroup()
        guard let userUuid = RYTHUserModel.retrieveUser()?.uuid else {
            return
        }
        let requestDate = Date().getDateStringWithYYYYMMDD()
        var url = "\(URL_CONSTANT.GROWTH_ZEN_STATUS)/\(userUuid)/\(requestDate)/\(requestDate)"
        getStatusGroup.enter()
        self.getRequest(url: url, param: nil) { (isSuccess, result, message) in
            if isSuccess {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    let statuses = try JSONDecoder().decode([RHYTStatusModel].self, from: jsonData)
                    statusMGR.updateWithStatuses(statuses[0])
                }
                catch {
                    
                }
            } else {
                
            }
            getStatusGroup.leave()
        }
        url = "\(URL_CONSTANT.GROWTH_SETUP_STATUS)/\(userUuid)"
        getStatusGroup.enter()
        self.getRequest(url: url, param: nil) { (isSuccess, result, message) in
            if isSuccess {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    let setupStatuses = try JSONDecoder().decode(RHYTGrowthToolSetupStatusModel.self, from: jsonData)
                    statusMGR.updateWithGrowthSetupStatuses(setupStatuses)
                }
                catch {
                    
                }
            } else {
                
            }
            getStatusGroup.leave()
        }
        getStatusGroup.enter()
        
        url = "\(URL_CONSTANT.GROWTH_SETUP_GOAL_GET)/\(userUuid)"
        self.getRequest(url: url, param: nil) { (isSuccess, result, message) in
            if isSuccess {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    let goal = try JSONDecoder().decode([RHYTGoalModel].self, from: jsonData)
                    if !goal.isEmpty {
                        userSetupMGR.updateWithGoalModel(goal[0])
                    }
                }
                catch {
                    
                }
            } else {
                
            }
            getStatusGroup.leave()
        }
        
        getStatusGroup.enter()
        url = "\(URL_CONSTANT.GROWTH_LOCK_TOOLS)/\(userUuid)"
        self.getRequest(url: url, param: nil) { (isSuccess, result, message) in
            if isSuccess {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    let lockStatuses = try JSONDecoder().decode(RHYTGrowthToolLockModel.self, from: jsonData)
                    statusMGR.updateWithLockStatuses(lockStatuses)
                    
                }
                catch {
                    
                }
            } else {
                
            }
            getStatusGroup.leave()
        }
        
        getStatusGroup.notify(queue: DispatchQueue.main) {[weak self] in
            self?.collectionView_growthTool.reloadData()
            let goalSetuped = (statusMGR.growthToolsSetupStatuses?.goals ?? false)
            let goalShouldChange = (statusMGR.growthToolsSetupStatuses?.isGoalShouldChange ?? false)
            let goal = !goalSetuped ? "GOAL : TO BE SETUP!" : "GOAL : \(userSetupMGR.goal)"
            self?.btnRandom.setTitle(goal, for: .normal)
            self?.setUpView.isHidden = !(!goalSetuped || goalShouldChange)
            self?.setupCancelButton.isHidden = !goalShouldChange
            self?.setupButton.setTitle(goalShouldChange ? "UPDATE" : "SETUP", for: .normal)
        }
    }
    
    func getGoal() {
        
    }
    
    func updateGoal(change: Bool, newGoal: String?) {
        let param = ["goal":change ? (newGoal ?? "") :userSetupMGR.goal,
                     "goalDate": change ? Date().getDateStringWithYYYYMMDD() : (userSetupMGR.goalModel?.goalDate ?? ""),
                     "changed": true] as [String:Any]
        let url = "\(URL_CONSTANT.GROWTH_SETUP_GOAL_SET)/\(userSetupMGR.goalModel?.uuid ?? "")"
        self.putRequest(url: url, param: param) {[weak self] (isSuccess, result, message) in
            if isSuccess {
                self?.getStatuses()
            } else {
                self?.showAlertOnSelf(message: message!)
            }
        }
    }
    
}
