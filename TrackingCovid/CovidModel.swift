//
//  CovidModel.swift
//  TrackingCovid
//
//  Created by Lawencon on 14/07/20.
//  Copyright © 2020 Lawencon. All rights reserved.
//

import Foundation
import UIKit

class CovidModel : Codable {
    let attributes : Attributes?
    
    enum CodingKeys: String, CodingKey {
        
        case attributes = "attributes"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attributes = try values.decodeIfPresent(Attributes.self, forKey: .attributes)
    }
    
}

    class Attributes : Codable {
        let fID : Int?
        let kode_Provi : Int?
        let provinsi : String?
        let kasus_Posi : Int?
        let kasus_Semb : Int?
        let kasus_Meni : Int?
        
        enum CodingKeys: String, CodingKey {
            
            case fID = "FID"
            case kode_Provi = "Kode_Provi"
            case provinsi = "Provinsi"
            case kasus_Posi = "Kasus_Posi"
            case kasus_Semb = "Kasus_Semb"
            case kasus_Meni = "Kasus_Meni"
        }
        
        required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            fID = try values.decodeIfPresent(Int.self, forKey: .fID)
            kode_Provi = try values.decodeIfPresent(Int.self, forKey: .kode_Provi)
            provinsi = try values.decodeIfPresent(String.self, forKey: .provinsi)
            kasus_Posi = try values.decodeIfPresent(Int.self, forKey: .kasus_Posi)
            kasus_Semb = try values.decodeIfPresent(Int.self, forKey: .kasus_Semb)
            kasus_Meni = try values.decodeIfPresent(Int.self, forKey: .kasus_Meni)
        }
        
}

