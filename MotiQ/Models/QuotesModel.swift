//
//  QuotesModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import Foundation


struct QuotesModel: Codable, Hashable {
    let q: String
    let a: String
    
    init(q: String, a: String) {
        self.q = q
        self.a = a
    }
}
   
