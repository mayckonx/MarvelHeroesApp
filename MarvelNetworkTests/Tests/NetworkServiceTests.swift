//
//  NetworkServiceTests.swift
//  MarvelNetworkTests
//
//  Created by Mayckon B on 15.11.20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Moya

@testable import MarvelNetwork

class NetworkServiceTests: XCTestCase {
    // MARK: - Target to be tested
    var sut: NetworkService!
    
    // MARK: - Auxiliar Variables
    var response: Observable<CharacterResponse>!
    var scheduler: TestScheduler!
    var bag: DisposeBag!

    // MARK: - Lifecycle
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        response = nil
        scheduler = nil
        bag = nil
    }
    
    // MARK: - Tests
    
    func testRequest_whenLoadingSuccessulResponse_shouldReturnMappedObject() {
        // Given
        let expectedResult = Bundle.loadResponse(name: "characters-response", target: NetworkServiceTests.self)!.decodeTo(object: CharacterResponse.self)!
        
        // Setup network service
        let provider = MoyaProvider<NetworkAPI>(endpointClosure: Endpoints.response, stubClosure: MoyaProvider.immediatelyStub)
        sut = NetworkService(provider: provider)
        
        // Response
        response = sut.request(.characters(nil))
        
        // When
        let result = try! response.toBlocking().first()!
        
        // Then
        XCTAssertEqual(result.characters, expectedResult.characters)
    }
    
    func testRequest_whenLoadingBrokenJson_shouldReturnInternalServerError() {
        // Given
        // 1. Expectation
        let exp = expectation(description: "Results")
        // 2. Service Network
        let provider = MoyaProvider<NetworkAPI>(endpointClosure: Endpoints.brokenResponse, stubClosure: MoyaProvider.immediatelyStub)
        sut = NetworkService(provider: provider)
        // 3. Response
        response = sut.request(.characters(nil))
        
        // When
        let result = scheduler.record(response, disposeBag: bag)
        exp.fulfill()
        
        waitForExpectations(timeout: 0.1) { _ in
            // Then
            XCTAssertEqual(result.events[0].value.error as? MarvelErrorResponse, MarvelErrorResponse.internalServerError)
        }
    }
    
    func testRequest_whenMakeUnauthorizedRequest_shouldReturnUnauthorizedError() {
        // Given
        // 1. Expectation
        let exp = expectation(description: "Results")
        // 2. Service Network
        let provider = MoyaProvider<NetworkAPI>(endpointClosure: Endpoints.unauthorizedResponse, stubClosure: MoyaProvider.immediatelyStub)
        sut = NetworkService(provider: provider)
        // 3. Response
        response = sut.request(.characters(nil))
        
        // When
        let result = scheduler.record(response, disposeBag: bag)
        exp.fulfill()
        
        waitForExpectations(timeout: 0.1) { _ in
            // Then
            XCTAssertEqual(result.events[0].value.error as? MarvelErrorResponse, MarvelErrorResponse.unauthorized)
        }
    }
    
}

// TODO: Add it to the Domain module

struct Character: Codable, Hashable {
    var id: Int = 0
    var name: String = ""
}

struct CharacterResponse: Decodable, Hashable {
    var characters: [Character]
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    private enum ResultKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try! container.nestedContainer(keyedBy: ResultKeys.self, forKey: .data)
        characters = try resultsContainer.decode([Character].self, forKey: .results)
    }
}

