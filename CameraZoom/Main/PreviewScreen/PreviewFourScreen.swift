//
//  PreviewOneScreen.swift
//  Camepa
//
//  Created by mac on 01.06.2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyStoreKit
import SafariServices

class PreviewFourScreen: UIViewController {
    
    let totalSize = UIScreen.main.bounds.size
    var activityIndicator = UIActivityIndicatorView()
    
    private let sharedSecret = "7a4f4540d67a4d83b9bc477d3601ac80"
    private let productID = "com.cameraZoomPro.fullFunctional"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupBackground()
        setupActivityIndicator()
        
        view.addSubview(activityIndicator)
        
        
        
        goButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        politickButton.addTarget(self, action: #selector(buttonPolitickAction(sender:)), for: .touchUpInside)
        serviceButton.addTarget(self, action: #selector(buttonServiceAction(sender:)), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(buttonRestoreAction(sender:)), for: .touchUpInside)
        
        gifView.loadGif(name: "rabbit")
        
//        titleLabel.isHidden = false
        descriptionView.isHidden = false
    }
    
    lazy var descriptionView: UIView =  {
//        var constant: CGFloat!
//        var leading: CGFloat!
//         if totalSize.height >= 815 {
//            constant = 300
//            leading = 40
//         } else if totalSize.height == 812 {
//            constant = 270
//            leading = 20
//        } else {
//            constant = 220
//            leading = 25
//        }
        
        var constant: CGFloat!
        var constantX: CGFloat!
        var height: CGFloat!
        var width: CGFloat!
         if totalSize.height >= 815 {
            constant = 320
            constantX = 40
            height = 240
            width = 350
         } else if totalSize.height >= 810 {
         constant = 300
         constantX = 20
         height = 240
         width = 350
         } else if totalSize.height >= 700 {
         constant = 270
         constantX = 30
         height = 230
         width = 350
         } else if totalSize.height >= 600 {
            constant = 230
            constantX = 20
            height = 240
            width = 350
         } else {
            constant = 180
            constantX = -5
            height = 220
            width = 350
        }
                let description = DescriptionView(frame: CGRect(x: constantX, y: constant, width: width, height: height))
                self.view.addSubview(description)
        
//                description.snp.makeConstraints { make in
//                    make.top.equalToSuperview().inset(constant)
//                    make.center.equalToSuperview()
//                    make.leading.trailing.equalToSuperview().inset(leading)
//                    make.height.equalTo(100)
//                    make.bottom.equalToSuperview().inset(constant)
//                }
                return description
            }()

//MARK: - backgroundImage
        lazy var backgroundImage: UIImageView =  {
            var background = UIImageView(image: #imageLiteral(resourceName: "background"))

            
            background.clipsToBounds = true
            background.contentMode = .scaleAspectFill
            self.view.addSubview(background)


            background.snp.makeConstraints { make in
                make.bottom.top.leading.trailing.equalToSuperview().inset(0)
                make.center.equalToSuperview()
//                make.height.equalTo(UIScreen.main.bounds.height)
               // make.height.equalTo(300)
            }
            return background
        }()
    private func setupBackground() {
        self.backgroundImage.isHidden = false
    }
//MARK: Button
    @objc lazy var goButton: UIButton = {
        
//        var constant: CGFloat!
//        var width: CGFloat!
//        var height: CGFloat!
//         if totalSize.height >= 800 {
//            constant = 120
//            width = 300
//            height = 55
//        } else if totalSize.height >= 600 {
//            constant = 80
//            width = 300
//            height = 55
//        } else {
//            constant = 80
//            width = 300
//            height = 55
//        }
        
        var constant: CGFloat!
        var width: CGFloat!
        var height: CGFloat!
         if totalSize.height >= 815 {
            constant = 150
            width = 330
            height = 55
         } else if totalSize.height >= 810 {
         constant = 140
         width = 300
         height = 53
         } else if totalSize.height >= 700 {
         constant = 120
         width = 330
         height = 55
         } else if totalSize.height >= 600 {
             constant = 110
             width = 300
             height = 50
         } else {
            constant = 110
            width = 270
            height = 45
        }
        
        let btn = UIButton()
        
        btn.setTitle(NSLocalizedString("Продолжить", comment: "Продолжить"), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0.593336165, blue: 0.2506197393, alpha: 1)
        btn.layer.cornerRadius = 25
        self.view.addSubview(btn)
//        let btn = UIButton()
//
//        btn.setImage(#imageLiteral(resourceName: "buttonBuy"), for: .normal)
//        btn.contentMode = .scaleAspectFit
//        self.view.addSubview(btn)

        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalToSuperview().inset(constant)
        }
        
        return btn
    }()
    
    @objc func buttonAction(sender: UIButton) {
//        activityIndicator.startAnimating()
//        
//        SwiftyStoreKit.purchaseProduct(productID, atomically: true) { [weak self] result in
//            guard let self = self else { return }
//            
//            if case .success(let purchase) = result {
//                // Deliver content from server, then:
//                if purchase.needsFinishTransaction {
//                    SwiftyStoreKit.finishTransaction(purchase.transaction)
//                }
//                
//                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.sharedSecret)
//                SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
//                    guard let self = self else { return }
//                    
//                    if case .success(let receipt) = result {
//                        let purchaseResult = SwiftyStoreKit.verifySubscription(
//                            ofType: .autoRenewable,
//                            productId: self.productID,
//                            inReceipt: receipt)
//                        
//                        switch purchaseResult {
//                        case .purchased(_, _):
                            self.goToCameraViewController()
//                            break
//                        case .expired(_, _):
//                            break
//                        case .notPurchased:
//                            break
//                        }
//
//                    } else {
//                        // receipt verification error
//                    }
//                }
//            } else {
//                // purchase error
//            }
//        }
        
    }
    
    private func showErrorRestoreAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Ошибка", comment: "Ошибка"), message: NSLocalizedString("Произошла ошибка при восстановлении покупки. Либо она просрочена, либо не была куплена", comment: "Сообщение ошибки"), preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: NSLocalizedString("Окей", comment: "Окей"), style: .default))
        
        present(alert, animated: true, completion: nil)
    }
//MARK: - Politick
    @objc lazy var politickButton: UIButton = {
            
//            var constant: CGFloat!
//            var leading: CGFloat!
//             if totalSize.height >= 815 {
//                constant = 50
//                leading = 50
//             } else if totalSize.height == 812 {
//                constant = 35
//                leading = 35
//            } else {
//                constant = 5
//                leading = 25
//            }
        
            var constant: CGFloat!
            var leading: CGFloat!
             if totalSize.height >= 815 {
                constant = 50
                leading = 50
             } else if totalSize.height >= 810 {
                 constant = 45
                 leading = 35
             } else if totalSize.height >= 700 {
                constant = 32
                leading = 25
             } else if totalSize.height >= 600 {
                 constant = 32
                 leading = 25
             } else {
                constant = 35
                leading = 25
            }
            
        
            let btn = UIButton()
            
            btn.setTitle(NSLocalizedString("Политика конфиденциальности", comment: "Политика конфиденциальности"), for: .normal)
            btn.setAttributedTitle(.none, for: .normal)
            
            btn.setTitleColor(#colorLiteral(red: 0, green: 0.5893694758, blue: 0.2509447634, alpha: 1), for: .normal)
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(constant)
            }
            
            return btn
        }()
        
        @objc func buttonPolitickAction(sender: UIButton) {
           showSafariVC(for: "http://zoom-camera.msk-top.ru/privacy_policy.pdf")
        }
//MARK: - Service
    @objc lazy var serviceButton: UIButton = {
                
//                var constant: CGFloat!
//                var leading: CGFloat!
//                 if totalSize.height >= 815 {
//                    constant = 20
//                    leading = 45
//                 } else if totalSize.height == 812 {
//                    constant = 35
//                    leading = 25
//                    } else {
//                    constant = 5
//                    leading = 15
//                }
                var constant: CGFloat!
                 if totalSize.height >= 815 {
                    constant = 20
                 } else if totalSize.height >= 810 {
                 constant = 15
                 } else if totalSize.height >= 700 {
                 constant = 5
                 } else if totalSize.height >= 600 {
                     constant = 0
                 } else {
                    constant = 0
                }
                
                let btn = UIButton()
                
                btn.setTitle(NSLocalizedString("Условия обслуживания", comment: "Условия обслуживания"), for: .normal)
                btn.setAttributedTitle(.none, for: .normal)
                
                btn.setTitleColor(#colorLiteral(red: 0, green: 0.5893694758, blue: 0.2509447634, alpha: 1), for: .normal)
                self.view.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
//                    make.trailing.equalToSuperview().inset(leading)

                    make.bottom.equalToSuperview().inset(constant)
                }
                
                return btn
            }()
            
            @objc func buttonServiceAction(sender: UIButton) {
               showSafariVC(for: "http://zoom-camera.msk-top.ru/privacy_policy.pdf")
            }
//MARK: - Restore
    @objc lazy var restoreButton: UIButton = {

//                var constant: CGFloat!
//                 if totalSize.height >= 800 {
//                    constant = 80
//                } else if totalSize.height >= 600 {
//                    constant = 35
//                } else {
//                    constant = 40
//                }
        
                var constant: CGFloat!
                 if totalSize.height >= 815 {
                    constant = 80
                 } else if totalSize.height >= 810 {
                 constant = 75
                 } else if totalSize.height >= 700 {
                 constant = 60
                 } else if totalSize.height >= 600 {
                     constant = 65
                 } else {
                    constant = 70
                }
        
                let btn = UIButton()
                
                btn.setTitle(NSLocalizedString("Восстановление покупок", comment: "Восстановление покупок"), for: .normal)
                btn.setAttributedTitle(.none, for: .normal)
                btn.setTitleColor(#colorLiteral(red: 0, green: 0.5893694758, blue: 0.2509447634, alpha: 1), for: .normal)
                self.view.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview().inset(constant)
//                    make.height.equalToSuperview().inset(1)
                }
                
                return btn
            }()
            
            @objc func buttonRestoreAction(sender: UIButton) {
                activityIndicator.startAnimating()

                SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
                    guard let self = self else { return }

                    if results.restoredPurchases.count > 0 {
                        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.sharedSecret)

                        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
                            guard let self = self else { return }

                            switch result {
                            case .success(let receipt):
                                let purchaseResult = SwiftyStoreKit.verifySubscription(
                                    ofType: .autoRenewable,
                                    productId: self.productID,
                                    inReceipt: receipt)

                                switch purchaseResult {
                                case .purchased( _, _):
                                    self.goToCameraViewController()
                                case .expired( _, _):
                                    self.showErrorRestoreAlert()
                                case .notPurchased:
                                    self.showErrorRestoreAlert()
                                }
                            case .error( _):
                                break
                            }

                            self.activityIndicator.stopAnimating()
                        }
                    } else {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
//MARK: - And
    lazy var titleLabel: UILabel = {
                
//                var constant: CGFloat!
//                 if totalSize.height >= 800 {
//                    constant = 40
//                } else {
//                    constant = 12
//                }
                
                var constant: CGFloat!
                 if totalSize.height >= 800 {
                    constant = 40
                } else if totalSize.height >= 600 {
                    constant = 12
                } else {
                    constant = -80
                }
        
                let title = UILabel()
                title.font = .systemFont(ofSize: 18, weight: .light)
                title.text = NSLocalizedString("и", comment: "й")
                title.textColor = .black
                title.textAlignment = .center
                title.numberOfLines = 0
                self.view.addSubview(title)
                
                title.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(constant)
                    make.centerX.equalToSuperview()
    //                make.height.equalTo(100)
                }
                return title
            }()
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    private func goToCameraViewController(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController

        //        let vc = CameraViewController()
                
        viewController.modalPresentationStyle = .fullScreen
                    
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        view.window!.layer.add(transition, forKey: kCATransition)
                    
        present(viewController, animated: false, completion: nil)
    }
    
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
    }
//MARK: - GifView
        lazy var gifView: UIImageView =  {
            
            var constant: CGFloat!
             if totalSize.height >= 815 {
                constant = 0
             } else if totalSize.height >= 810 {
             constant = 10
             } else if totalSize.height >= 700 {
             constant = -60
             } else if totalSize.height >= 600 {
                 constant = -60
             } else {
                constant = -50
            }
            
            var gifView = UIImageView()

            gifView.clipsToBounds = true
//            gifView.layer.cornerRadius = 5
            gifView.contentMode = .scaleAspectFit
            self.view.addSubview(gifView)
            
            
            gifView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(constant)
                make.height.equalTo(UIScreen.main.bounds.width)
               // make.height.equalTo(300)
            }
            return gifView
        }()
}
