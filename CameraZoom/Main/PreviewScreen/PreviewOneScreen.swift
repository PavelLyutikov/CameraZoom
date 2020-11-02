//
//  PreviewOneScreen.swift
//  Camepa
//
//  Created by mac on 01.06.2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class PreviewOneScreen: UIViewController {

    let totalSize = UIScreen.main.bounds.size
    
        override func viewDidLoad() {
            super.viewDidLoad()

            
            setupBackground()
            setupLabel()
            
            
            
            gifView.loadGif(name: "zoom")
            goButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        }
//MARK: - Label
    
    lazy var titleLabel: UILabel = {
        
//        var constant: CGFloat!
//         if totalSize.height >= 800 {
//            constant = 500
//        } else {
//            constant = 400
//        }
        
        var constant: CGFloat!
         if totalSize.height >= 800 {
            constant = 500
        } else if totalSize.height >= 600 {
            constant = 400
        } else {
            constant = 320
        }
        
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .light)
        title.text = NSLocalizedString("Приближайте нужный объект для фото до x100 крат увеличения! Для лучшей фокусировки объекта рекомендуем установить телефон на штатив.", comment: "Описание супер зум")
        title.textColor = .black
        title.textAlignment = .center
        title.numberOfLines = 0
        self.view.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(constant)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        return title
    }()
    lazy var titleLbl: UILabel = {
 
//        var constant: CGFloat!
//         if totalSize.height >= 800 {
//            constant = 420
//        } else {
//            constant = 330
//        }
        
        var constant: CGFloat!
         if totalSize.height >= 800 {
            constant = 420
        } else if totalSize.height >= 600 {
            constant = 330
        } else {
            constant = 240
        }
        
        let title = UILabel()
        title.font = .systemFont(ofSize: 25, weight: .medium)
        title.textColor = .black
        title.textAlignment = .center
        title.numberOfLines = 0
        title.attributedText = NSAttributedString(string: NSLocalizedString("СУПЕР ZOOM", comment: "Супер зум"), attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        self.view.addSubview(title)
        
    
        
        title.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(constant)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        return title
    }()
    private func setupLabel() {
        titleLabel.isHidden = false
        titleLbl.isHidden = false
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
    
//MARK: Button
        @objc lazy var goButton: UIButton = {
            
            var constant: CGFloat!
             if totalSize.height >= 800 {
                constant = 80
            } else {
                constant = 40
            }
            
            let btn = UIButton()
            
            btn.setTitle(NSLocalizedString("Продолжить", comment: "Продолжить"), for: .normal)
            btn.backgroundColor = #colorLiteral(red: 0, green: 0.593336165, blue: 0.2506197393, alpha: 1)
            btn.layer.cornerRadius = 25
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
    //            make.leading.trailing.equalToSuperview().inset(40)
                make.height.equalTo(55)
                make.width.equalTo(300)
                make.bottom.equalToSuperview().inset(constant)
            }
            
            return btn
        }()
        
        @objc func buttonAction(sender: UIButton) {
        
                    let vc = PreviewTwoScreen()
        
            vc.modalPresentationStyle = .fullScreen
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            view.window!.layer.add(transition, forKey: kCATransition)

            present(vc, animated: false, completion: nil)

                }
//MARK: - GifView
            lazy var gifView: UIImageView =  {
                
                var constant: CGFloat!
                 if totalSize.height >= 800 {
                    constant = 60
                } else {
                    constant = 0
                }
                
                var gifView = UIImageView()

                gifView.clipsToBounds = true
    //            gifView.layer.cornerRadius = 5
                gifView.contentMode = .scaleAspectFit
                self.view.addSubview(gifView)
                
                
                gifView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(60)
                    make.top.equalToSuperview().inset(constant)
                    make.height.equalTo(UIScreen.main.bounds.width)
                   // make.height.equalTo(300)
                }
                return gifView
            }()
}
