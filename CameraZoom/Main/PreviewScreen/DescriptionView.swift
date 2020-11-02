//
//  DescriptionView.swift
//  CameraZoom
//
//  Created by Admin on 03/08/2020.
//  Copyright © 2020 6connex China. All rights reserved.
//

import UIKit

class DescriptionView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    private let titles = [NSLocalizedString("Супер Zoom x100 увеличение", comment: "тайтл1"), NSLocalizedString("Доступ к макро съемке", comment: "тайтл2"), NSLocalizedString("Никакой рекламы", comment: "тайтл3"), NSLocalizedString("Бесплатно 3 дня", comment: "тайтл4")]
    private let descriptions = [NSLocalizedString("максимальное приближение", comment: "дескрипшион1"), NSLocalizedString("снимайте мелкие детали", comment: "дескрипшион2"), NSLocalizedString("полный функционал", comment: "дескрипшион3"), NSLocalizedString("потом 34,99 $ / неделю", comment: "дескрипшион4")]
    private let images = [#imageLiteral(resourceName: "я2"), #imageLiteral(resourceName: "я4"), #imageLiteral(resourceName: "я3"), #imageLiteral(resourceName: "я1")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DescriptionView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        for (index, view) in descriptionStackView.subviews.enumerated() {
            guard let cellView = view as? CellView else { return }
            
            cellView.cellImageView.image = images[index]
            cellView.cellTitleLabel.text = titles[index]
            cellView.cellDescriptionLabel.text = descriptions[index]
        }
    }
}
