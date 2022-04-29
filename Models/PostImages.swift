//
//  PostImages.swift
//  RentalCar
//
//  Created by Ivan on 26.04.2022.
//

import Foundation

struct PostImagesResult: Decodable {
    let success : Bool
//    let data: PostImagesResultData?
}

struct PostImagesResultData: Decodable {
    let name: String?
    let message: String?
    let code: Int?
    let status: Int?
}
