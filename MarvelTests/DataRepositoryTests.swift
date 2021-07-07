//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by Mark Dalton on 7/3/21.
//

import XCTest
@testable import Marvel

class DataRepositoryTests: XCTestCase {
    
    var sut: DataRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        sut = DataRepository(context: context)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testMarvelApiFetchCharactersOneCall() throws {
        // given
        let promise = expectation(description: "Completion handler returns CharacterResult")
        let offset = Int.zero
        var responseError: Error?
        var numberOfChars = Int.zero
        
        // when
        sut.fetchCharactersFromRemote(withOffset: offset) { result in
            switch result {
            case .success(let characters):
                numberOfChars = characters.count
                if characters.count > Int.zero {
                    promise.fulfill()
                } else {
                    XCTFail("No characters returned.")
                }
            case .failure(let error):
                responseError = error
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertNotEqual(numberOfChars, Int.zero)
    }

}
