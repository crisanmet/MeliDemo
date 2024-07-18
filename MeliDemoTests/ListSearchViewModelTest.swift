//
//  ListSearchViewModelTest.swift
//  MeliDemoTests
//
//  Created by Cristian Sancricca on 17/07/2024.
//

import XCTest
import Factory
@testable import MeliDemo

final class ListSearchViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: Constants.UserDefault.recentSearches)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Container.shared.apiManager.reset()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testInitialization() {
        let sut = ListSearchViewModel()
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertTrue(sut.recentSearches.isEmpty)
        XCTAssertTrue(sut.items.isEmpty)
        XCTAssertFalse(sut.isEditing)
    }
    
    func testLoadRecentSearches() {
        UserDefaults.standard.set(["search1", "search2"], forKey: Constants.UserDefault.recentSearches)
        let sut = ListSearchViewModel()
        XCTAssertEqual(sut.recentSearches, ["search1", "search2"])
    }
    
    func testSaveRecentSearches() {
        UserDefaults.standard.set(["search1", "search2"], forKey: Constants.UserDefault.recentSearches)
        let sut = ListSearchViewModel()
        sut.recentSearches = ["search1", "search2"]
        let savedSearches = UserDefaults.standard.array(forKey: Constants.UserDefault.recentSearches) as? [String]
        XCTAssertEqual(savedSearches, ["search1", "search2"])
    }
    
    func testLoadDataSuccess() async {
        let mockData: SearchResponse = loadJSONFromBundle("mockSearchResponse", as: SearchResponse.self)
        let mockService = MockService(mockData: mockData)
        
        Container.shared.apiManager.register(factory: { mockService })
        
        let sut = ListSearchViewModel()
        sut.searchText = "Motorola"
        await sut.loadData()
        
        XCTAssertEqual(sut.items.count, mockData.items.count)
    }
    
    func testLoadDataFailWithNullResponse() async {
        let mockService = MockService(mockData: nil)
        Container.shared.apiManager.register(factory: { mockService })
        
        let sut = ListSearchViewModel()
        sut.searchText = "Motorola"
        await sut.loadData()
        
        XCTAssertEqual(sut.items.count, 0)
        XCTAssertEqual(sut.state, .failed(errorTitle: "Algo salio mal!"))
    }
    
    func testLoadDataFailWithNoInternet() async {
        let mockData: SearchResponse = loadJSONFromBundle("mockSearchResponse", as: SearchResponse.self)
        let mockService = MockService(mockData: mockData, hasInternet: false)
        Container.shared.apiManager.register(factory: { mockService })

        let sut = ListSearchViewModel()
        sut.searchText = "Motorola"
        await sut.loadData()
        
        XCTAssertEqual(sut.items.count, 0)
        XCTAssertEqual(sut.state, .failed(errorTitle: "¡Parece que no hay conexión a internet"))
    }
    
    func testLoadMoreItems() async {
        let mockItems = (1...150).map {
            ItemModel(
                id: "\($0)",
                title: "Item \($0)", 
                condition: nil,
                categoryID: nil,
                thumbnailID: nil,
                currencyID: nil,
                price: nil,
                originalPrice: nil,
                salePrice: nil,
                availableQuantity: nil,
                pictures: nil,
                seller: nil,
                attributes: nil,
                discounts: nil,
                promotions: nil
            )
        }
        
        let mockPaging = PagingModel(total: 150, primaryResults: 150, offset: 0, limit: 50)
        let mockResponse = SearchResponse(paging: mockPaging, items: Array(mockItems.prefix(50)))
        
        let mockService = MockService(mockData: mockResponse)
        Container.shared.apiManager.register(factory: { mockService })
        
        let sut = ListSearchViewModel()
        sut.searchText = "Motorola"
        
        await sut.loadData()
        
        // Load first 50 items
        XCTAssertEqual(sut.items.count, 50)
        XCTAssertEqual(sut.items.first?.title, "Item 1")
        XCTAssertEqual(sut.items.last?.title, "Item 50")
        
        // Load next 50 items
        let mockResponseNextPage = SearchResponse(paging: mockPaging, items: Array(mockItems[50..<100]))
        mockService.mockData = mockResponseNextPage
        
        sut.loadMoreItems()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(sut.items.count, 100)
        XCTAssertEqual(sut.items[50].title, "Item 51")
        XCTAssertEqual(sut.items.last?.title, "Item 100")
        
        // Load last 50 items
        let mockResponseLastPage = SearchResponse(paging: mockPaging, items: Array(mockItems[100..<150]))
        mockService.mockData = mockResponseLastPage
        
        sut.loadMoreItems()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(sut.items.count, 150)
        XCTAssertEqual(sut.items[100].title, "Item 101")
        XCTAssertEqual(sut.items.last?.title, "Item 150")
        
        // Try to load more items
        sut.loadMoreItems()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(sut.items.count, 150, "Items count should be 150")
    }
}
