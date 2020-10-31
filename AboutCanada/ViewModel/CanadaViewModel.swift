//
//  CanadaViewModel.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.


import Foundation
class CandaViewModel {
    
    private let cellData: [Asset]?
    
    //Dependency Injection
    init(cellData: [Asset]) {
        self.cellData = cellData
    }
    
    func sendData() -> [Asset]? {
        guard let data = self.cellData else { return nil}
        return data
    }
    

}
