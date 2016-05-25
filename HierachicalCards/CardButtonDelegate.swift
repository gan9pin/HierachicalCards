//
//  CardButtonDelegate.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/24.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation

protocol CardButtonDelegate{
    func cardTransition(card: Card)->Void
    func showCard(card: Card)->Void
}