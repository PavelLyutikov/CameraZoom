//
//  SettingViewController.swift
//  Camepa
//
//  Created by mac on 15.06.2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

class SettingTableViewController: UITableViewController {
    
    var sections = sectionsData
    
    let totalSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(closeSettingButton(sender:)))
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
//        tableView.estimatedRowHeight = 44.0
//        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.titleView = barLabel
        
        politickButton.addTarget(self, action: #selector(politickAction(sender:)), for: .touchUpInside)
        
        conditionsButton.addTarget(self, action: #selector(conditionsAction(sender:)), for: .touchUpInside)
        
        supportButton.addTarget(self, action: #selector(supportAction(sender:)), for: .touchUpInside)
        
    }
    lazy var barLabel: UILabel = {
            let title = UILabel()
//            title.font = UIFont(name: "Cochin", size: 28)
            title.text = "Настройки"
            title.textColor = .white
            title.textAlignment = .center

            self.view.addSubview(title)
            
            title.snp.makeConstraints { make in
                make.height.equalTo(50)
    //            make.width.equalTo(200)
            }
            
            return title
        }()
    
    @objc func closeSettingButton(sender: UIButton) {

        let vc = CameraViewController()

        
             vc.modalPresentationStyle = .fullScreen
                 
                 let transition = CATransition()
                 transition.duration = 0.4
                 transition.type = CATransitionType.push
                 transition.subtype = CATransitionSubtype.fromLeft
                 transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                 view.window!.layer.add(transition, forKey: kCATransition)
                 
             present(vc, animated: false, completion: nil)
    }
    
//MARK: - politickButton
        @objc lazy var politickButton: UIButton = {
            
            var constant: CGFloat!

             if totalSize.height >= 800 {
                constant = 5

            } else {
                constant = 5

            }
            
            
            
            
            let btn = UIButton()
            
//            btn.setImage(#imageLiteral(resourceName: "video"), for: .normal)
            btn.setTitle("Политика конфиденциальности", for: .normal)
            btn.setAttributedTitle(.none, for: .normal)
            
            btn.setTitleColor(.white, for: .normal)
//            btn.setBackgroundImage(#imageLiteral(resourceName: "buttonGo"), for: .normal)
            

            self.view.addSubview(btn)
            
//            [yourBtnHere setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal]

            btn.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.equalToSuperview().inset(constant)
            }
            
            return btn
        }()

    
    
    @objc func politickAction(sender: UIButton) {

        showSafariVC(for: "http://zoom-camera.msk-top.ru/privacy_policy.pdf")
        }
    
    //MARK: - conditionsButton
            @objc lazy var conditionsButton: UIButton = {
                
                var constant: CGFloat!

                 if totalSize.height >= 800 {
                    constant = 45

                } else {
                    constant = 45

                }
                
                let btn = UIButton()
                
    //            btn.setImage(#imageLiteral(resourceName: "video"), for: .normal)
                btn.setTitle("Условия использования", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                self.view.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(16)
                    make.top.equalToSuperview().inset(constant)
                }
                
                return btn
            }()

        
        
        @objc func conditionsAction(sender: UIButton) {

            showSafariVC(for: "http://zoom-camera.msk-top.ru/terms_of_use.pdf")
            }
    
    //MARK: - politickButton
            @objc lazy var supportButton: UIButton = {
                
                var constant: CGFloat!

                 if totalSize.height >= 800 {
                    constant = 90

                } else {
                    constant = 90

                }
                
                let btn = UIButton()
                
    //            btn.setImage(#imageLiteral(resourceName: "video"), for: .normal)
                btn.setTitle("Поддержка", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                self.view.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(16)
                    make.top.equalToSuperview().inset(constant)
                }
                
                return btn
            }()

        
        
        @objc func supportAction(sender: UIButton) {

            showSafariVC(for: "https://docs.google.com/forms/d/e/1FAIpQLSfDNv6WpQ-cguIonDVbrgY56W___DrBi3qk_ODAhGR8O5jf_g/viewform")
            }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    

}


// MARK: - View Controller DataSource and Delegate
//
//extension SettingTableViewController {
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].collapsed ? 0 : sections[section].items.count
//    }
//
//    // Cell
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SettingTableViewCell ??
//            SettingTableViewCell(style: .default, reuseIdentifier: "cell")
//
//        let item: Item = sections[indexPath.section].items[indexPath.row]
//
//        cell.nameLabel.text = item.name
//        cell.detailLabel.text = item.detail
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    // Header
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
//
//        header.titleLabel.text = sections[section].name
//        header.arrowLabel.text = ">"
//        header.setCollapsed(sections[section].collapsed)
//
//        header.section = section
//        header.delegate = self
//
//        return header
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44.0
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 1.0
//    }
//
//}
//
////
//// MARK: - Section Header Delegate
////
//extension SettingTableViewController: CollapsibleTableViewHeaderDelegate {
//
//    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
//        let collapsed = !sections[section].collapsed
//
//        // Toggle collapse
//        sections[section].collapsed = collapsed
//        header.setCollapsed(collapsed)
//
//        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
//    }
//
//}

