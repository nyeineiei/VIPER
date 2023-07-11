import XCTest
@testable import VIPER

class UserInteractorTests: XCTestCase {
    var session: URLSession!
    var interactor: UserInteractor!
    var output: MockInteractorOutput?

    override func setUp() {
        super.setUp()
        session = URLSession(configuration: .default)
        interactor = UserInteractor()
    }

    override func tearDown() {
        session = nil
        interactor = nil
        super.tearDown()
    }

    func testGetUsers_SuccessfulResponse() {
        let expectation = XCTestExpectation(description: "Successful response")
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        
        interactor.output = MockInteractorOutput(expectation: expectation)
        output = interactor.output as? MockInteractorOutput
        interactor.getUsers(session: session, from: url)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertFalse(output!.users!.isEmpty)
    }

    func testGetUsers_FailedResponse() {
        let expectation = XCTestExpectation(description: "Failed response")
        let url = URL(string: "https://invalid-url.com")
        
        interactor.output = MockInteractorOutput(expectation: expectation)
        output = interactor.output as? MockInteractorOutput
        interactor.getUsers(session: session, from: url)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(output!.users!.count, 0)
        XCTAssertFalse(output!.error!.localizedDescription.isEmpty)
    }
    
    func testGetUsers_EmptyURL() {
        let expectation = XCTestExpectation(description: "Empty URL")
        let url: URL? = nil // Set the URL to nil or an empty URL
        
        interactor.output = MockInteractorOutput(expectation: expectation)
        
        interactor.getUsers(session: session, from: url)

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetUsers_DecodingFailure() {
        let expectation = XCTestExpectation(description: "Decoding failure")
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        let invalidData = Data("invalidData".utf8)
        let session = MockURLSession(data: invalidData, urlResponse: nil, error: nil)
        
        interactor.output = MockInteractorOutput(expectation: expectation) // MockInteractorOutput implements AnyInteractorOutput
        
        interactor.getUsers(session: session, from: url)

        wait(for: [expectation], timeout: 5.0)
        // Additional assertions can be performed based on the expected behavior
    }
}

// Mock implementation of AnyInteractorOutput for testing purposes
class MockInteractorOutput: AnyInteractorOutput {
    let expectation: XCTestExpectation
    var users: [User]?
    var error: Error?
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func success(users: [User]) {
        // Perform assertions based on the expected behavior
        self.users = users
        expectation.fulfill()
    }

    func failed(error: Error) {
        // Perform assertions based on the expected behavior
        self.error = error
        self.users = [User]()
        expectation.fulfill()
    }
}

// MockURLSession subclass for testing purposes
class MockURLSession: URLSession {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let error: Error?

    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let mockDataTask = MockURLSessionDataTask()
        completionHandler(data, urlResponse, error)
        return mockDataTask
    }
}

// MockURLSessionDataTask subclass for testing purposes
class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        // Do nothing in the mock implementation
    }
}
