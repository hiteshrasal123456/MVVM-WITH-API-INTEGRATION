//
//  LoginModel.swift
//  MVVMArchitecture
//
//  Created by Tejora on 05/02/20.
//  Copyright © 2020 Tejora. All rights reserved.
//

import UIKit

struct LoginModel : Codable {
    var totalCount : Int?
    var records : [MovieModel]?
    enum CodingKeys: String, CodingKey {
        case totalCount = "totalCount"
        case records    = "results"
    }
    
}

struct MovieModel: Codable {
    var artistName: String?
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
    }
}
