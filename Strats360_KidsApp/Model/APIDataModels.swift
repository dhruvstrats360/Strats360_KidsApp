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
    let banner: String
    let data: [HomePageData]
    
    init(status: Int, message: String, logo: String,banner: String, data: [HomePageData]){
        self.status = status
        self.message = message
        self.banner = banner
        self.logo = logo
        self.data = data
    }
    
}
//MARK: HomePageData
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

// MARK:  ChapterDataModel
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

// MARK: - ProfilePageAPIModel
struct ProfilePageAPIModel: Codable {
    var status, message: String
    var data: ProfilePageModel
}

// MARK:  ProfilePageModel
struct ProfilePageModel: Codable {
    let id: Int
    var name, email, phone: String
    var image: String
    var updated_at: String
}
// MARK: - DescriptionPageModel

struct DescriptionPageModel: Codable {
    let status, message: String
    let screenData: [ScreenDatum]

    enum CodingKeys: String, CodingKey {
        case status, message
        case screenData = "ScreenData"
    }
}

// MARK: ScreenDatum
struct ScreenDatum: Codable {
    let pageID: String
    let logo, image: String
    let title, subtitle: String

    enum CodingKeys: String, CodingKey {
        case pageID = "page_id"
        case logo = "Logo"
        case image, title, subtitle
    }
}
