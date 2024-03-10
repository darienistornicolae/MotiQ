import XCTest
@testable import MotiQ

final class MotiQTests: XCTestCase {
    var sut: CoreDataViewModel!

    func testAddQuoteToCoreData() {
        let quote = "I'm here"
        let author = "Me"

        let savedData: () = sut.addQuote(quote: quote, author: author)
        XCTAssertNoThrow(savedData, "doesn't throw")
    }

    func testIsNotSavedQuote() {
        let sut = MotivationalViewModel()
        XCTAssertFalse(sut.isSaved, "it is saved")
    }

    func testSavedQuote() {
        let sut = MotivationalViewModel()
        sut.toggleSaveQuote()
        XCTAssertTrue(sut.isSaved, "it is not saved")
    }
}
