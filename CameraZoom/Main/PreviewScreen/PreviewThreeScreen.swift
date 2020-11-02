//
//  PreviewThreeScreen.swift
//  Camepa
//
//  Created by mac on 02.06.2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SnapKit

class PreviewThreeScreen: UIViewController {
    
    let totalSize = UIScreen.main.bounds.size
    var isTapped = false
    
    let modelIpohe = ["iPhone SE 2",
                   "iPhone 11 Pro",
                   "iPhone 11",
                   "iPhone XS",
                   "iPhone XR",
                   "iPhone 8",
                   "iPhone 7",
                   "iPhone SE",
                   "iPhone 6S",
                   "iPhone 6",
                   "iPhone 5S",
                   "iPhone 5",
                   "iPhone 4S"]
       
       var selectedIphone: String?
    
//MARK: - ViewDidLoad
            override func viewDidLoad() {
                super.viewDidLoad()

                
                setupBackground()
                setupBackgroundText()
                setupLabel()
                
                
                goButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
                
                setupButton()
                
                buttonTap.addTarget(self, action: #selector(buttonTapAction(sender:)), for: .touchUpInside)
                
                createDayPicker()
                createToolbar()
            }
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
//MARK: - LabelSetting
        lazy var titleLabel: UILabel = {
            
            var constant: CGFloat!
            var constantLeading: CGFloat!
             if totalSize.height >= 800 {
                constant = 100
                constantLeading = 35
            } else {
                constant = 100
                constantLeading = 30
            }
            
            let title = UILabel()
            title.font = .systemFont(ofSize: 18, weight: .light)
            title.text = NSLocalizedString("Модель iPhone:", comment: "Модель")
            title.textColor = .black
            title.textAlignment = .center
            title.numberOfLines = 0
            self.view.addSubview(title)
            
            title.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(constant)
                make.leading.equalToSuperview().inset(constantLeading)
//                make.height.equalTo(100)
            }
            return title
        }()
    
        lazy var titleLbl: UILabel = {
            
            var constant: CGFloat!
            var sizeFnt: CGFloat!
             if totalSize.height >= 800 {
                constant = 30
                sizeFnt = 25
            } else {
                constant = 30
                sizeFnt = 23
            }
            
            let title = UILabel()
            title.font = .systemFont(ofSize: sizeFnt, weight: .medium)
            title.attributedText = NSAttributedString(string: NSLocalizedString("НАСТРОЙКА ZOOM КАМЕРЫ", comment: "Настройка"), attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
            title.textAlignment = .center
            title.textColor = .black
            title.numberOfLines = 0
            self.view.addSubview(title)
            
            title.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(constant)
                make.leading.trailing.equalToSuperview().inset(3)
//                make.height.equalTo(100)
            }
            return title
        }()
    
        lazy var zoomLabel: UILabel = {
                    
                var constant: CGFloat!
                var constantLeading: CGFloat!
                 if totalSize.height >= 800 {
                    constant = 220
                    constantLeading = 35
                } else {
                    constant = 220
                    constantLeading = 30
                }
                
                let title = UILabel()
                title.font = .systemFont(ofSize: 18, weight: .light)
                title.text = NSLocalizedString("Фокусировка:", comment: "Фокусировка")
                title.textAlignment = .center
                title.textColor = .black
                title.numberOfLines = 0
                self.view.addSubview(title)
                
                title.snp.makeConstraints { make in
                    make.top.equalTo(view.safeAreaLayoutGuide).inset(constant)
                    make.leading.equalToSuperview().inset(constantLeading)
    //                make.height.equalTo(100)
                }
                return title
            
            }()
            
        private func setupLabel() {
            titleLabel.isHidden = false
            titleLbl.isHidden = false
            zoomLabel.isHidden = false
            textField.isHidden = false
        }
//MARK: - TextField
    lazy var textField: UITextField = {
        let textFld = UITextField()
        
        var constant: CGFloat!
        var constantLeading: CGFloat!
        var sizeFont: CGFloat!
         if totalSize.height >= 800 {
            constant = 155
            constantLeading = 35
            sizeFont = 18
        } else if totalSize.height >= 600 {
            constant = 147
            constantLeading = 30
            sizeFont = 18
        } else {
            constant = 147
            constantLeading = 30
            sizeFont = 15
        }
        
//        var constant: CGFloat!
//         if totalSize.height >= 800 {
//            constant = 500
//        } else if totalSize.height >= 600 {
//            constant = 400
//        } else {
//            constant = 320
//        }
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textFld.leftView = paddingView
        textFld.leftViewMode = .always
        textFld.placeholder = NSLocalizedString("Введите модель вашего телефона", comment: "Ввод модели")
//        textFld.isSecureTextEntry = true
        textFld.autocorrectionType = .no
        textFld.font = .systemFont(ofSize: sizeFont, weight: .light)
        textFld.autocapitalizationType = UITextAutocapitalizationType.none
        textFld.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Введите модель вашего телефона", comment: "Ввод модели"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFld.tintColor = UIColor.white
//        textFld.borderStyle = .none
//        textFld.layer.borderColor = UIColor.white.cgColor
//        textFld.layer.borderWidth = 0.7
        textFld.textColor = UIColor.black
        self.view.addSubview(textFld)
        
        textFld.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(constant)
            make.leading.equalToSuperview().inset(constantLeading)
        //                make.height.equalTo(100)
                    }
        
        return textFld
    }()
//MARK: - BackgroundText
            lazy var backgroundText: UIImageView =  {
                
//                var constant: CGFloat!
//                var width: CGFloat!
//                var height: CGFloat!
//                var leading: CGFloat!
//                 if totalSize.height >= 800 {
//                    constant = 180
//                    width = 375
//                    height = 55
//                    leading = 20
//                } else {
//                    constant = 155
//                    width = 335
//                    height = 45
//                    leading = 20
//                }
                
                var constant: CGFloat!
                var width: CGFloat!
                var height: CGFloat!
                var leading: CGFloat!
                     if totalSize.height >= 815 {
                        constant = 182
                        width = 375
                        height = 50
                        leading = 20
                     } else if totalSize.height <= 700 {
                        constant = 155
                        width = 335
                        height = 45
                        leading = 20
                     } else if totalSize.height == 812 {
                        constant = 185
                        width = 375
                        height = 45
                        leading = 20
                     } else {
                        constant = 155
                        width = 335
                        height = 45
                        leading = 20
                }
                
                var background = UIImageView(image: #imageLiteral(resourceName: "white-background"))

                background.layer.cornerRadius = 23
                background.clipsToBounds = true
                background.contentMode = .scaleAspectFill
                self.view.addSubview(background)


                background.snp.makeConstraints { make in
                            make.centerX.equalToSuperview()
//                           make.leading.equalToSuperview().inset(constantLeading)
                    make.leading.trailing.equalToSuperview().inset(leading)
                            make.height.equalTo(height)
//                            make.width.equalTo(width)
                            make.top.equalToSuperview().inset(constant)
                        }
                return background
            }()
        private func setupBackgroundText() {
            self.backgroundText.isHidden = false
        }
    
//MARK: Button
            @objc lazy var goButton: UIButton = {
                
//                var constant: CGFloat!
//                 if totalSize.height >= 800 {
//                    constant = 80
//                } else {
//                    constant = 40
//                }
                
                var constant: CGFloat!
                var height: CGFloat!
                var width: CGFloat!
                 if totalSize.height >= 800 {
                    height = 55
                    constant = 80
                    width = 300
                } else if totalSize.height >= 600 {
                    constant = 40
                    height = 55
                    width = 300
                } else {
                    height = 55
                    width = 350
                    constant = 40
                }
                
                
                let btn = UIButton()
                
                btn.setTitle(NSLocalizedString("Продолжить", comment: "Продолжить"), for: .normal)
                btn.backgroundColor = #colorLiteral(red: 0, green: 0.593336165, blue: 0.2506197393, alpha: 1)
                btn.layer.cornerRadius = 25
                self.view.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
//                    make.leading.trailing.equalToSuperview().inset(40)
                    make.height.equalTo(55)
                    make.width.equalTo(300)
                    make.bottom.equalToSuperview().inset(constant)
                }
                
                return btn
            }()
            
            @objc func buttonAction(sender: UIButton) {
                
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
//                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
//
//                //        let vc = CameraViewController()
//                        
//                            viewController.modalPresentationStyle = .fullScreen
//                            
//                            let transition = CATransition()
//                            transition.duration = 0.4
//                            transition.type = CATransitionType.push
//                            transition.subtype = CATransitionSubtype.fromRight
//                            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
//                            view.window!.layer.add(transition, forKey: kCATransition)
//                            
//                            present(viewController, animated: false, completion: nil)

                let vc = PreviewFourScreen()

                    vc.modalPresentationStyle = .fullScreen

                    let transition = CATransition()
                    transition.duration = 0.4
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                    view.window!.layer.add(transition, forKey: kCATransition)

                    present(vc, animated: false, completion: nil)
            }
    
//MARK: - ButtonZoom
            lazy var buttonZoom: UIImageView =  {
                
                var constant: CGFloat!
                var leading: CGFloat!
                var height: CGFloat!
                 if totalSize.height >= 800 {
                    constant = 300
                    leading = 20
                    height = 55
                } else {
                    constant = 270
                    leading = 20
                    height = 55
                }
                
                var zoom = UIImageView(image: #imageLiteral(resourceName: "button-1"))

                
                zoom.clipsToBounds = true
                zoom.contentMode = .scaleAspectFit
                self.view.addSubview(zoom)


                zoom.snp.makeConstraints { make in
                            make.centerX.equalToSuperview()
                            make.leading.trailing.equalToSuperview().inset(leading)
                            make.height.equalTo(height)
//                            make.width.equalTo(width)
                            make.top.equalToSuperview().inset(constant)
                        }
                return zoom
            }()
//MARK: - ButtonMacro
    lazy var buttonMacro: UIImageView =  {
        
        var constant: CGFloat!
        var leading: CGFloat!
        var height: CGFloat!
         if totalSize.height >= 800 {
            constant = 300
            leading = 20
            height = 55
        } else {
            constant = 270
            leading = 20
            height = 55
        }
        
        var zoom = UIImageView(image: #imageLiteral(resourceName: "button2-1"))

        
        zoom.clipsToBounds = true
        zoom.contentMode = .scaleAspectFit
        self.view.addSubview(zoom)


        zoom.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.leading.trailing.equalToSuperview().inset(leading)
                    make.height.equalTo(height)
//                    make.width.equalTo(width)
                    make.top.equalToSuperview().inset(constant)
                }
        return zoom
    }()
    
    @objc lazy var buttonTap: UIButton = {
            
            var constant: CGFloat!
            var width: CGFloat!
            var height: CGFloat!
             if totalSize.height >= 800 {
                constant = 300
                width = 375
                height = 55
            } else {
                constant = 270
                width = 335
                height = 55
            }
            
            let btn = UIButton()
            
//            btn.setImage(#imageLiteral(resourceName: "button2"), for: .normal)
//            btn.contentMode = .scaleAspectFit
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
            //            make.leading.trailing.equalToSuperview().inset(40)
                        make.height.equalTo(height)
                        make.width.equalTo(width)
                        make.top.equalToSuperview().inset(constant)
                    }
            
            return btn
        }()
    
    
    private func setupButton() {
//        buttonMacro.isHidden = false
        buttonZoom.isHidden = false
    }
        @objc func buttonTapAction(sender: UIButton) {
            
            isTapped = !isTapped

            let fromView = isTapped ? buttonZoom : buttonMacro
            let toView = isTapped ? buttonMacro : buttonZoom
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.curveLinear, .showHideTransitionViews])
        }


    
//MARK: - UIPicker
    func createDayPicker() {
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        textField.inputView = dayPicker
            textField.textAlignment = .left
        
        //Customizations
        dayPicker.backgroundColor = .gray
    }
    
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .lightGray
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Готово", comment: "Готово"), style: .plain, target: self, action: #selector(PreviewThreeScreen.dismissKeyboard))
        
        
        toolBar.setItems([doneButton], animated: false)

        
        toolBar.isUserInteractionEnabled = true

        textField.inputAccessoryView = toolBar
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension PreviewThreeScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modelIpohe.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modelIpohe[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIphone = modelIpohe[row]
        textField.text = selectedIphone
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        
        label.text = modelIpohe[row]
        
        return label
    }
}
