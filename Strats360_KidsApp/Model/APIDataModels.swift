//
//  APIDataModels.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 31/01/23.
//

import Foundation
import UIKit

struct HomePageAPIModel: Codable {
    let status: Int
    let message: String
    let logo: String
    let data: [Datum]
    
    init(status: Int, message: String, logo: String, data: [Datum]){
        self.status = status
        self.message = message
        self.logo = logo
        self.data = data
    }
    
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name: String
    let image: String
    init(id: Int, name: String, image: String){
        self.id = id
        self.name = name
        self.image = image
    }
}

