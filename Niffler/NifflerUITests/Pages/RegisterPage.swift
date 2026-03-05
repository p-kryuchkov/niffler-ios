import XCTest

class RegisterPage: BasePage {

    private var usernameField: XCUIElement {
        let q = app.textFields.matching(identifier: "userNameTextField")
        // Берём тот, по которому реально можно тапнуть
        return q.allElementsBoundByIndex.first(where: { $0.isHittable }) ?? q.firstMatch
    }

    private var passwordField: XCUIElement {
        let q = app.secureTextFields.matching(identifier: "passwordTextField")
        return q.allElementsBoundByIndex.first(where: { $0.isHittable }) ?? q.firstMatch
    }

    private var confirmPasswordField: XCUIElement {
        let q = app.secureTextFields.matching(identifier: "confirmPasswordTextField")
        return q.allElementsBoundByIndex.first(where: { $0.isHittable }) ?? q.firstMatch
    }

    @discardableResult
    func input(login: String, password: String) -> Self {
        XCTContext.runActivity(named: "Регистрирую \(login), \(password)") { _ in
            input(login: login)
            input(password: password)
            input(confirmPassword: password)
            pressSignUpButton()
            pressSuccessRegisterButton()
        
        }
        return self
    }
    
    func assertIsUsernameEquals(expected: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю логин = \(expected)") { _ in
            XCTAssertTrue(usernameField.waitForExistence(timeout: 5), "Не найден userNameTextField", file: file, line: line)
            let value = usernameField.value as? String
            XCTAssertEqual(value, expected, file: file, line: line)
        }
    }
    
    func assertIsPasswordNotNull(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что пароль введён") { _ in
            XCTAssertTrue(passwordField.waitForExistence(timeout: 5), "Не найден passwordTextField", file: file, line: line)
            let value = (passwordField.value as? String) ?? ""
            XCTAssertFalse(value.isEmpty, "Пароль пустой", file: file, line: line)
        }
    }

    private func input(login: String) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            XCTAssertTrue(usernameField.waitForExistence(timeout: 5))
            usernameField.tap()
            usernameField.typeText(login)
        }
    }

    private func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
            passwordField.tap()
            passwordField.typeText(password)
        }
    }

    private func input(confirmPassword: String) {
        XCTContext.runActivity(named: "Подтверждаю пароль \(confirmPassword)") { _ in
            XCTAssertTrue(confirmPasswordField.waitForExistence(timeout: 5))
            confirmPasswordField.tap()
            confirmPasswordField.typeText(confirmPassword)
            app.keyboards.buttons["Return"].tap()
        }
    }

    private func pressSignUpButton() {
        XCTContext.runActivity(named: "Жму кнопку Sign Up") { _ in
            app.buttons["Sign Up"].tap()
        }
    }
    
    private func pressSuccessRegisterButton() {
        XCTContext.runActivity(named: "Жму кнопку подтверждения регистрации") { _ in
            waitSuccessRegisterButton()
            app.alerts["Congratulations!"].buttons["Log in"].tap()
        }
    }
    
    
    @discardableResult
    func waitSuccessRegisterButton(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let isFound = app.alerts["Congratulations!"].buttons["Log in"]
            .waitForExistence(timeout: 10)
        
        XCTAssertTrue(isFound,
                      "Не дождались кнопки подтверждения логина",
                      file: file, line: line)
        
        return self
    }
}
