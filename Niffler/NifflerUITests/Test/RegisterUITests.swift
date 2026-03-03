import XCTest

final class RegisterUITests: TestCase {
    
    func test_RegisterSuccess() throws {
        
        launchAppWithoutLogin()

        // Act
        loginPage.pressRegisterButton()
        registerPage.input(login: "TestDefaultUser10", password: "12345")
        
        // Assert
        loginPage.assertIsUsernameEquals(expected: "TestDefaultUser10")
        loginPage.assertIsPasswordNotNull()
    }
    
    func test_LoginDataIsTransferredToRegistrationScreen() throws {
        
        launchAppWithoutLogin()

        // Act
        loginPage.inputWithoutLogin(login: "TestDefaultUser10", password: "12345")

        loginPage.pressRegisterButton()
   //     registerPage.input(login: "TestDefaultUser10", password: "12345")
        
        // Assert
        registerPage.assertIsUsernameEquals(expected: "TestDefaultUser10")
        registerPage.assertIsPasswordNotNull()
    }
}
