import XCTest

final class RegisterUITests: TestCase {
    
    func test_RegisterSuccess() throws {
        // Arrange
        launchAppWithoutLogin()

        // Act
        loginPage.pressRegisterButton()
        registerPage.input(login: "TestDefaultUser10", password: "12345")
        
        // Assert
        loginPage.assertIsUsernameEquals(expected: "TestDefaultUser10")
        loginPage.assertIsPasswordNotNull()
    }
}
