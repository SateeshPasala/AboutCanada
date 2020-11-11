//
//  AboutCanadaTests.swift
//  AboutCanadaTests
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.
//

import XCTest
@testable import AboutCanada

class AboutCanadaTests: XCTestCase {
    
    var infoList: CellData?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let data =  CanadaInfoJsonString().jsonDataString.data(using:.utf8)!
        let decoder = JSONDecoder()
        infoList = try? decoder.decode(CellData.self, from: data)
    }
    
    func testProductionServiceRunning() {
        // Put the code you want to measure the time of here.
        setUp()
        let expectation = self.expectation(description: "Get  service is failed and we don't receive correct response")
        Networking.fetchData { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            default:
                XCTFail("Expected get  service response with error json")
            }
        }
        self.waitForExpectations(timeout: 6.0)
    }
    
    func testServiceError() {
        let expectation = self.expectation(description: "Looks like, latest data is not present")
        Networking.fetchData(shouldFail: true) { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            default:
                XCTFail("Expected get service response with error json")
                
            }
        }
        self.waitForExpectations(timeout: 6.0)
    }
    
    func testNavigationBarTitle() {
        XCTAssertEqual(infoList?.title!, "About Canada")
        XCTAssertNotEqual(infoList?.title!, " Canada")
    }
    
    func testDescreption() {
        XCTAssertNotNil(infoList?.rows?.first?.description)
        
    }
    
    func testTitle() {
        XCTAssertNotNil(infoList?.rows?.first?.title)
        
    }
    
    func testImageLink() {
        XCTAssertNotNil(infoList?.rows?.first?.imageHref)
    }
    
    func testInternetConnection(){
        XCTAssertEqual(Networking.connectedToNetwork(), MockConectionChecker.isInternetConnected())

    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    class MockConectionChecker {
        
       public static func isInternetConnected() -> Bool{
            Networking.connectedToNetwork()
        }
    }
}
