//
//  ExampleData.swift
//  Camepa
//
//  Created by mac on 15.06.2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation


// MARK: - Section Data Structure
//
public struct Item {
    var name: String
    var detail: String
    
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}

public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, items: [Item], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}


public var sectionsData: [Section] = [
    Section(name: "Политика конфиденциальности", items: [
        Item(name: "", detail: "http://zoom-camera.msk-top.ru/privacy_policy.pdf")/*,
        Item(name: "MacBook Air", detail: "While the screen could be sharper, the updated 11-inch MacBook Air is a very light ultraportable that offers great performance and battery life for the price."),
        Item(name: "MacBook Pro", detail: "Retina Display The brightest, most colorful Mac notebook display ever. The display in the MacBook Pro is the best ever in a Mac notebook."),
        Item(name: "iMac", detail: "iMac combines enhanced performance with our best ever Retina display for the ultimate desktop experience in two sizes."),
        Item(name: "Mac Pro", detail: "Mac Pro is equipped with pro-level graphics, storage, expansion, processing power, and memory. It's built for creativity on an epic scale."),
        Item(name: "Mac mini", detail: "Mac mini is an affordable powerhouse that packs the entire Mac experience into a 7.7-inch-square frame."),
        Item(name: "OS X El Capitan", detail: "The twelfth major release of OS X (now named macOS)."),
        Item(name: "Accessories", detail: "")*/
    ]),
    Section(name: "Условия использования", items: [
        Item(name: "", detail: "http://zoom-camera.msk-top.ru/terms_of_use.pdf")/*,
        Item(name: "iPad Air 2", detail: "The second-generation iPad Air tablet computer designed, developed, and marketed by Apple Inc."),
        Item(name: "iPad mini 4", detail: "iPad mini 4 puts uncompromising performance and potential in your hand."),
        Item(name: "Accessories", detail: "")*/
    ]),
    Section(name: "Поддержка", items: [
        Item(name: "", detail: "https://docs.google.com/forms/d/e/1FAIpQLSfDNv6WpQ-cguIonDVbrgY56W___DrBi3qk_ODAhGR8O5jf_g/viewform")
    ])
]
