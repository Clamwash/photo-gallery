import XCTest

class MyAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testNavigationToDetailScreen() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))

        let cellTitle = firstCell.staticTexts["MainScreenTitleLabel"].label
        
        firstCell.tap()

        let detailScreenTitle = app.staticTexts["DetailScreenTitleLabel"].label

        XCTAssertEqual(cellTitle, detailScreenTitle)
    }
}
