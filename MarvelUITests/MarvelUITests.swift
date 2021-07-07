//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by Mark Dalton on 7/3/21.
//

import XCTest

class MarvelUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchBarOpensKeyboard() {
        // given
        let searchBar = app.searchFields["Search"]
        
        // when
        searchBar.tap()
        
        // then
        XCTAssertTrue(app.keyboards.count > Int.zero)
    }
    
    func testSearchBarCanSearch() {
        // given
        let searchBar = app.searchFields["Search"]
        let searchText = "Spiderman"
        
        // when
        searchBar.tap()
        searchBar.typeText(searchText)
        
        // then
        XCTAssertTrue(searchBar.value is String && (searchBar.value as! String) == searchText)
    }
}
