//
//  MovieBrowserTests.swift
//  MovieBrowserTests
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import XCTest
@testable import MovieBrowser

final class MovieBrowserTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        // MARK: Test hours and minutes
        XCTAssertEqual(165.convertToMovieLength(), "2h 45m")
        
        // MARK: Test hours (with 0 minutes)
        XCTAssertEqual(120.convertToMovieLength(), "2h")
        
        // MARK: Test less than 60m
        XCTAssertEqual(20.convertToMovieLength(), "20m")
    }

}
