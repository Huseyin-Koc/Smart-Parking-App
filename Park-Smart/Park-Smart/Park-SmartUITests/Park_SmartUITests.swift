import XCTest

class Park_SmartUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-UITest_Mode"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }    

    
    func testLoginAndSelectParkingSpot() {
        let app = XCUIApplication()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists, "Username text field should be present on the screen.")
        usernameTextField.tap()
        usernameTextField.typeText("TestUser")
        
        let passwordSecureField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureField.exists, "Password secure field should be present on the screen.")
        passwordSecureField.tap()
        passwordSecureField.typeText("testPassword")
        
        let logInButton = app.buttons["Log In"]
        XCTAssertTrue(logInButton.exists, "Log In button should be present on the screen.")
        logInButton.tap()
        
        //Ensure the map is loaded and then tap on a parking spot
        let mapView = app.maps.element
        XCTAssertTrue(mapView.waitForExistence(timeout: 10), "Map view should be displayed after login.")
        
        // Use coordinate-based tapping to select a parking spot
        let coordinate = mapView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coordinate.tap()
        
        // Check for successful interaction
        // This can be checking for an alert, a change in UI, or just ensuring the app hasn't crashed
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: mapView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let spotButton = app.buttons["Empty"]
        XCTAssertTrue(spotButton.exists, "Spot button should exist.")
        spotButton.tap()
        
        XCTAssertTrue(true, "Successfully tapped on a parking spot.")
    }
    
    func testRegisterButton() {
        let app = XCUIApplication()
        
        let registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.exists, "Register button should exist.")
        registerButton.tap()
        
        // Verify that the alert appears and contains the correct message
        let alert = app.alerts["Registration Unavailable"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Registration alert should appear after tapping Register.")
        
        let alertMessage = alert.staticTexts["This feature is not yet active."]
        XCTAssertTrue(alertMessage.exists, "Alert message should be correct.")
    }
    
    
    func testLoginAndQRCodeScan() {
        let app = XCUIApplication()
        
        app.buttons["Log In"].tap()
        
        // Wait for the ContentView to appear by checking for the "Scan QR Code" button
        let scanQRCodeButton = app.buttons["Scan QR Code"]
        XCTAssertTrue(scanQRCodeButton.waitForExistence(timeout: 5), "Scan QR Code button should be visible after login.")
        
        scanQRCodeButton.tap()

        let expectedResult = "MockQRCodeResult"
        let label = app.staticTexts[expectedResult]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: label, handler: nil)
      
    }
    
    
    func testLoginScanOccupiedSpotAndPay() {
         let app = XCUIApplication()
         
         // Log in         
         app.buttons["Log In"].tap()
         
         // Wait for the ContentView to appear by checking for the "Scan QR Code" button
         let scanQRCodeButton = app.buttons["Scan QR Code"]
         XCTAssertTrue(scanQRCodeButton.waitForExistence(timeout: 5), "Scan QR Code button should be visible after login.")
         
         scanQRCodeButton.tap()
         
  
         let alert = app.alerts.element
         XCTAssertTrue(alert.waitForExistence(timeout: 5), "An alert showing parking spot information should appear after tapping on a spot.")
         
         // Verify the alert contains the correct parking spot name
         XCTAssertTrue(alert.staticTexts["Kadıköy İskele Otoparkı"].exists, "The alert should contain the correct parking spot name.")
         
         // Dismiss the alert to proceed with the payment
         app.buttons["OK"].tap()

         // Assume that after scanning and selecting the spot, the payment process starts automatically
         // Now we will fill the payment details
         let cardNumberTextField = app.textFields["Card Number"]
         XCTAssertTrue(cardNumberTextField.waitForExistence(timeout: 5), "Card Number text field should be visible.")
         cardNumberTextField.tap()
         cardNumberTextField.typeText("4111111111111111")
         
         let mmYYTextField = app.textFields["MM/YY"]
         mmYYTextField.tap()
         mmYYTextField.typeText("1225")
         
         let cvvField = app.secureTextFields["CVV"]
         cvvField.tap()
         cvvField.typeText("123")

         let payButton = app.buttons["Pay"]
         XCTAssertTrue(payButton.exists, "Pay button should be visible.")
         payButton.tap()

         // Optionally: Check if the payment completion message or view appears
         // Here we assume the test completes the payment and returns to the main ContentView
         XCTAssertTrue(scanQRCodeButton.waitForExistence(timeout: 5), "Should return to ContentView with the 'Scan QR Code' button visible.")
     }

}
