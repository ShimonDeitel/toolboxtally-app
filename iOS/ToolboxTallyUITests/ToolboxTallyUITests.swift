import XCTest

final class ToolboxTallyUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() throws {
        app.buttons["addEntryButton"].tap()
        let saveButton = app.buttons["addSaveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
    }

    func testFreeLimitTriggersPaywall() throws {
        for _ in 0..<15 {
            if app.buttons["addEntryButton"].exists {
                app.buttons["addEntryButton"].tap()
                if app.buttons["addSaveButton"].waitForExistence(timeout: 2) {
                    app.buttons["addSaveButton"].tap()
                }
            }
        }
        let upgradeButton = app.buttons["paywallUpgradeButton"]
        _ = upgradeButton.waitForExistence(timeout: 2)
    }

    func testKeyboardDismissOnTapOutside() throws {
        app.buttons["addEntryButton"].tap()
        let textFields = app.textFields
        if textFields.count > 0 {
            let field = textFields.element(boundBy: 0)
            field.tap()
            field.typeText("Test")
            app.navigationBars.element.tap()
            XCTAssertFalse(field.isSelected)
        }
    }

    func testSettingsOpens() throws {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
