//
//  Constants.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.
//


import Foundation

public enum ConstantNumber: Int {
    case noOfRows = 0
}

///End point urls
public enum EndPoints: String {
    case prod = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    case test = "https://www.google.com"
}

public enum ConstantStrings: String {
    case okButtonTitle = "OK"
    case titleError = "no title available"
    case descreptionError = "no description available"
}
