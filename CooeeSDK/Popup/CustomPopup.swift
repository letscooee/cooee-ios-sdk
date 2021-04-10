//
//  CustomPopup.swift
//  CooeeSDK
//
//  Created by Surbhi Lath on 09/03/21.
//

import UIKit

class CustomPopup: UIView {
    @IBOutlet var parentView: UIView!
    static let instance = CustomPopup()
    var layoutaData: TriggerData?
    var popUPView = UIView()
    var videoPlayer: VideoView?
    var loaderView = CircularProgressView()
    override init (frame : CGRect) {
        super.init(frame : frame)
        //Bundle.main.loadNibNamed("CustomPopup", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        _ = nib.instantiate(withOwner: self, options: nil).first as! UIView
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func updateViewWith(data: TriggerData, on viewcontroller: UIViewController){
        layoutaData = data
        addTriggerToList(triggerID: data.id, duration: "\(data.duration ?? 0)")
        switch data.triggerBackground.type {
        case .BLURRED:
            addBlurEffect(with: Double(data.triggerBackground.blur)/100 )
        case .SOLID_COLOR:
           break
        case .IMAGE:
           break
        }
        popUPView = UIView()
        
        switch data.background.type{
        case .BLURRED:
            addBlurEffect(with: Double(data.background.opacity)/100 )
        case .SOLID_COLOR:
            popUPView.backgroundColor = UIColor(hexString: data.background.color).withAlphaComponent(0.5)
        case .IMAGE:
            let imageView = UIImageView()
            imageView.frame = popUPView.bounds
            if let imageURL = URL(string: data.background.image){
                addImage(with: imageURL, to: imageView)
            }
            popUPView.addSubview(imageView)
        }
    
        popUPView.layer.cornerRadius = CGFloat(data.background.radius)
       
        switch data.fill {
        case .COVER:
            popUPView.frame = parentView.bounds
        case .INTERSTITIAL:
            popUPView.frame = CGRect(x: 20, y: 50, width: parentView.frame.width-40, height: parentView.frame.height-90)
        case .HALF_INTERSTITIAL:
            popUPView.frame.size = CGSize(width: parentView.frame.width-40, height: parentView.frame.height/2)
            popUPView.center = CGPoint(x: parentView.frame.size.width/2,
                                         y: parentView.frame.size.height/2)
        }
        
        let animation = CATransition()
        animation.duration = 0.5
        switch data.entranceAnimation {
        case .SLIDE_IN_DOWN:
            animation.type = CATransitionType.moveIn
            animation.subtype = CATransitionSubtype.fromTop
        case .SLIDE_IN_TOP:
            animation.type = CATransitionType.moveIn
            animation.subtype = CATransitionSubtype.fromBottom
        case .SLIDE_IN_LEFT:
            animation.type = CATransitionType.moveIn
            animation.subtype = CATransitionSubtype.fromRight
        case .SLIDE_IN_RIGHT:
            animation.type = CATransitionType.moveIn
            animation.subtype = CATransitionSubtype.fromLeft
        }
        viewcontroller.view.addSubview(parentView)
        popUPView.layer.add(animation, forKey: nil)
        parentView.addSubview(popUPView)
       
        //Accounting for safe area
        var safeAreaInsets = CGFloat()
        if data.fill == .COVER{
            let window = UIApplication.shared.windows[0]
            safeAreaInsets = window.safeAreaInsets.top
        }
       
        let vMainStackView = UIStackView()
        vMainStackView.axis = .vertical
        vMainStackView.alignment = .fill
        vMainStackView.distribution = .fill
        vMainStackView.spacing = 20
        vMainStackView.frame = CGRect(x: 20 , y: safeAreaInsets + 20, width: popUPView.frame.width-40,  height:popUPView.frame.height - (safeAreaInsets + 40))
        popUPView.addSubview(vMainStackView)
        
        //Title
        let vTextStackView = UIStackView()
        vTextStackView.axis = .vertical
        vTextStackView.alignment = .fill
        vTextStackView.distribution = .fill
        vTextStackView.spacing = 10
        let labelTitle = addLabelOfType(message: data.title)
         
        //Message
        let labelMessage = addLabelOfType( message: data.message)
        vTextStackView.addArrangedSubview(labelTitle)
        vTextStackView.addArrangedSubview(labelMessage)
       
        //Image/Video
        let vImageStackView = UIStackView()
        vImageStackView.axis = .vertical
        vImageStackView.alignment = .fill
        vImageStackView.distribution = .fill
        vImageStackView.frame.size = CGSize(width: popUPView.frame.width-40, height: popUPView.frame.height/2)
        vImageStackView.center = vMainStackView.center
        let viewForVideoAndImage = UIView()
        viewForVideoAndImage.frame.size =  CGSize(width: popUPView.frame.width-40, height: popUPView.frame.height/2)
        vImageStackView.addArrangedSubview(viewForVideoAndImage)
        switch data.type {
        case .IMAGE:
            let imageview = UIImageView()
            imageview.frame = viewForVideoAndImage.frame
            viewForVideoAndImage.addSubview(imageview)
            imageview.bounds = viewForVideoAndImage.bounds
            imageview.contentMode = .scaleToFill
            imageview.layer.cornerRadius = 8
            if let imageURL = URL(string: data.imageURL){
                addImage(with: imageURL, to: imageview)
            }
        case .VIDEO:
            videoPlayer = VideoView.init(frame: viewForVideoAndImage.frame)
            if let player = videoPlayer{
                player.configure(url:"https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")
                player.isLoop = true
                player.play()
                viewForVideoAndImage.addSubview(player)
            }
        }
        
        
        switch data.title.position {
        case .TOP:
            vMainStackView.addArrangedSubview(vTextStackView)
            vMainStackView.addArrangedSubview(vImageStackView)
        case .DOWN:
            vMainStackView.addArrangedSubview(vImageStackView)
            vMainStackView.addArrangedSubview(vTextStackView)
        case .RIGHT:
            break
        case .LEFT:
            break
        }
        
        //Action Buttons
        let vActionStackView = UIStackView()
        vActionStackView.axis = .vertical
        vActionStackView.alignment = .center
        vActionStackView.distribution = .fill
        vActionStackView.frame.size = CGSize(width: popUPView.frame.width - 40, height: 40)
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .center
        hStackView.spacing = 20
        for button in data.buttons{
            let buttonTemp = UIButton()
            buttonTemp.backgroundColor = UIColor(hexString: button.background)
            buttonTemp.setTitle("   \(button.text)   ", for: .normal)
            buttonTemp.setTitleColor(UIColor(hexString: button.color), for: .normal)
            buttonTemp.layer.cornerRadius = CGFloat(Int(button.radius) ?? 0)
            buttonTemp.addTarget(self, action: #selector(actionButtonTarget), for: .touchUpInside)
            let buttonTitleSize = button.text.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
            buttonTemp.frame.size = CGSize(width: buttonTitleSize.width + 10, height: 40)
            hStackView.addArrangedSubview(buttonTemp)
        }
        
        vActionStackView.addArrangedSubview(hStackView)
        vMainStackView.addArrangedSubview(vActionStackView)
        
        
        //Close button
        let closeButton = UIButton()
        let attributedTitle = NSAttributedString(string: "x  ",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        closeButton.setAttributedTitle(attributedTitle, for: .normal)
        closeButton.addTarget(self, action: #selector(removeFromSuper), for: .touchUpInside)
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        let vCloseStackView = UIStackView()
        vCloseStackView.axis = .vertical
        vCloseStackView.alignment = .fill
        vCloseStackView.distribution = .fill
        vCloseStackView.frame.size = CGSize(width: 30, height: 30)
        
        if data.closeBehaviour.auto{
            vCloseStackView.addArrangedSubview(closeButton)
            Timer.scheduledTimer(timeInterval: TimeInterval(data.closeBehaviour.timeToClose) , target: self, selector: #selector(removeFromSuper), userInfo: nil, repeats: false)
        }else{
            loaderView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            vCloseStackView.addArrangedSubview(loaderView)
            loadCircularView(){
                self.loaderView.removeFromSuperview()
                vCloseStackView.addArrangedSubview(closeButton)
            }
        }
        
        switch data.closeBehaviour.position {
        case .TOP_LEFT:
            vCloseStackView.frame.origin = CGPoint(x: 20, y: safeAreaInsets + 20)
        case .TOP_RIGHT:
            vCloseStackView.frame.origin = CGPoint(x: popUPView.frame.width-40, y:safeAreaInsets + 20)
        case .DOWN_LEFT :
            vCloseStackView.frame.origin = CGPoint(x: 20, y: popUPView.frame.height-40)
        case .DOWN_RIGHT:
            vCloseStackView.frame.origin = CGPoint(x: popUPView.frame.width-40, y: popUPView.frame.height-40)
        }
        popUPView.addSubview(vCloseStackView)
    }

    @objc func loadCircularView(closure:@escaping ()->()){
       if let timeToClose = layoutaData?.closeBehaviour.timeToClose{
        loaderView.progressAnimation(duration: TimeInterval(timeToClose), value: 1)
        delay(Double(timeToClose)) {
            closure()
        }
       }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func addLabelOfType(message: Message)->UILabel{
        let labelTxt = UILabel()
        labelTxt.text = message.text
        labelTxt.textColor = UIColor(hexString: message.color)
        labelTxt.font = UIFont.systemFont(ofSize: CGFloat(message.size))
        labelTxt.textAlignment = .center
        labelTxt.numberOfLines = 0
        labelTxt.frame.size = CGSize(width: popUPView.frame.width-40, height: 40)
        return labelTxt
    }
    
    @objc func removeFromSuper(){
        let animationExit = CATransition()
        animationExit.duration = 0.5
        animationExit.repeatCount = 0
        CATransaction.setCompletionBlock {
            
            self.popUPView.removeFromSuperview()
            self.parentView.removeFromSuperview()
        }
        switch layoutaData?.exitAnimation {
        case .SLIDE_OUT_TOP:
            animationExit.type = CATransitionType.push
            animationExit.subtype = CATransitionSubtype.fromTop
        case .SLIDE_OUT_BOTTOM:
            animationExit.type = CATransitionType.push
            animationExit.subtype = CATransitionSubtype.fromBottom
        case .SLIDE_OUT_LEFT:
            animationExit.type = CATransitionType.push
            animationExit.subtype = CATransitionSubtype.fromRight
        case .SLIDE_OUT_RIGHT:
            animationExit.type = CATransitionType.push
            animationExit.subtype = CATransitionSubtype.fromLeft
        case .none:
            break
        }
        self.videoPlayer?.stop()
        self.popUPView.layer.add(animationExit, forKey: nil)
        self.popUPView.isHidden = true
        CATransaction.commit()
    }

    @objc func actionButtonTarget(_ sender: UIButton){
        var customProperties = [String: String]()
        var customPayload = [String: String]()
        if let data = layoutaData{
            for button in data.buttons{
                if "   \(button.text)   " == sender.titleLabel!.text {
                    customProperties = button.action.userProperty
                    customPayload = button.action.kv
                }
            }
        }
        let registerUserInstance = Cooee.shared
        registerUserInstance.updateProfile(withProperties: customProperties, andData: nil)
       // registerUserInstance.buttonClickDelegate?.getPayload(info: customPayload)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "buttonClickListener"), object: nil, userInfo: customPayload)
    }
    
    func addImage(with url: URL, to: UIImageView){
        DispatchQueue.main.async {
            let data = try? Data(contentsOf: url)
            if let imagedata = data{
                to.image = UIImage(data: imagedata)
            }
        }
    }
    
    func addTriggerToList(triggerID: String, duration: String) {
        let data = TriggerDataModel(triggerId: triggerID, triggerDuration: duration)
        var list = UserSession.getTriggerData()
        list.append(data)
        UserSession.save(triggerData: list)
    }
    
    func addBlurEffect(with alpha: Double){
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = parentView.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parentView.addSubview(blurEffectView)
    }
}
