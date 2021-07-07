//
//  MarvelListViewModelTests.swift
//  MarvelTests
//
//  Created by Mark Dalton on 7/5/21.
//

import XCTest
@testable import Marvel

class MarvelListViewModelTests: XCTestCase {

    var sut: MarvelListViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        sut = MarvelListViewModel(dataRepo: DataRepository(context: context))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFetchCharacters() {
        // given
        let promise = expectation(description: "Fetch All Characters")
        var charactersExist = false
        
        // when
        sut.testFetchCharactersFromRemote { characterModels in
            charactersExist = characterModels.count > Int.zero
            promise.fulfill()
        }
        wait(for: [promise], timeout: 20)
        
        // then
        XCTAssertTrue(charactersExist)
    }

}
