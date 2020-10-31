//
//  CanadaListCellDataSource.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.
//

import UIKit

final class CanadaListCellDataSource {
    private let asset: Asset?
    
    //Dependencies injection
    init(asset: Asset) {
        self.asset = asset
    }
}

extension CanadaListCellDataSource: CandaListCellData {
    

    ///  cell title
    var title:String{
        guard let asset = asset else {
            return ""
        }
        return asset.title ?? ""
        
    }
    
    ///  cell body
    var body: String {
        guard let asset = asset else {
            return ""
        }
        return asset.description ?? ""
      
    }
    
    
    /// image url string
    var icon: String {
            guard let asset = asset else {
                return ""
            }
            return asset.imageHref ?? ""
            
        }
}

