//
//  DataModel.swift
//  MachineTest-Webandcrafts
//
//  Created by Harvin Shibu on 21/09/23.
//

import Foundation

// MARK: - DataModel
struct DataModel: Hashable, Codable {
    let status: Bool
    let homeData: [HomeData]
}

// MARK: - HomeDatum
struct HomeData: Hashable, Codable  {
    let type: String
    let values: [Value]
}

// MARK: - Value
struct Value:  Hashable, Codable {
    let id: Int
    let name: String?
    let imageURL, bannerURL: String?
    let image: String?
    let actualPrice, offerPrice: String?
    let offer: Int?
    let isExpress: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case bannerURL = "banner_url"
        case image
        case actualPrice = "actual_price"
        case offerPrice = "offer_price"
        case offer
        case isExpress = "is_express"
    }
}
