//
//  APIDataModels.swift
//  Strats360_KidsApp
//
//  Created by Strats 360 on 31/01/23.
//

import Foundation
import UIKit

//MARK: - HomePageAPIModel
struct HomePageAPIModel: Codable {
    let status: Int
    let message: String
    let logo: String
    let data: [HomePageData]
    
    init(status: Int, message: String, logo: String, data: [HomePageData]){
        self.status = status
        self.message = message
        self.logo = logo
        self.data = data
    }
    
}
//MARK: Datum
struct HomePageData: Codable {
    let id: Int
    let name: String
    let image: String
    init(id: Int, name: String, image: String){
        self.id = id
        self.name = name
        self.image = image
    }
}

//MARK: - ChapterPageAPI Model

struct ChapterPageAPIModel: Codable {
    let status, message: String
    let categoryWiseData: [CategoryWiseDatum]
    let data: [ChapterDataModel]

    enum CodingKeys: String, CodingKey {
        case status, message
        case categoryWiseData = "category_wise_data"
        case data
    }
}

// MARK:  CategoryWiseDatum
struct CategoryWiseDatum: Codable {
    let nameOrImage: String

    enum CodingKeys: String, CodingKey {
        case nameOrImage = "name_or_image"
    }
}

// MARK:  Datum
struct ChapterDataModel: Codable {
    let id: Int
    let categoryID, name: String
    let image: String
    let sound: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case name, image, sound
    }
}


