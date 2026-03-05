import XCTest

class LoginPage: BasePage {

    private var usernameField: XCUIElement {
        let q = app.textFields.matching(identifier: "userNameTextField")
        return q.allElementsBoundByIndex.first(where: { $0.isHittable }) ?? q.firstMatch
    }

    private var passwordField: XCUIElement {
        let q = app.secureTextFields.matching(identifier: "passwordTextField")
        return q.allElementsBoundByIndex.first(where: { $0.isHittable }) ?? q.firstMatch
    }

    private var loginButton: XCUIElement {
        app.buttons["loginButton"]
    }

    private var createAccountText: XCUIElement {
        app.staticTexts["Create new account"]
    }

    @discardableResult
    func input(login: String, password: String) -> Self {
        XCTContext.runActivity(named: "Авторизуюсь \(login), \(password)") { _ in
            input(login: login)
            input(password: password)
            pressLoginButton()
        }
        return self
    }
    
    @discardableResult
    func inputWithoutLogin(login: String, password: String) -> Self {
        XCTContext.runActivity(named: "Ввожу логин и пароль без нажатия на кнопку логина \(login), \(password)") { _ in
            input(login: login)
            input(password: password)
            app.keyboards.buttons["Return"].tap()
        }
        return self
    }

    private func input(login: String) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            XCTAssertTrue(usernameField.waitForExistence(timeout: 5), "Не найден userNameTextField")
            usernameField.tap()
            usernameField.typeText(login)
        }
    }

    private func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            XCTAssertTrue(passwordField.waitForExistence(timeout: 5), "Не найден passwordTextField")
            passwordField.tap()
            passwordField.typeText(password)
        }
    }

    private func pressLoginButton() {
        XCTContext.runActivity(named: "Жму кнопку логина") { _ in
            XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Не найдена кнопка loginButton")
            loginButton.tap()
        }
    }

    func pressRegisterButton() {
        XCTContext.runActivity(named: "Жму кнопку Регистрации") { _ in
            XCTAssertTrue(createAccountText.waitForExistence(timeout: 5), "Не найден текст Create new account")
            createAccountText.tap()
        }
    }

    // MARK: - Asserts

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

    func assertIsLoginErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let isFound = app.staticTexts["LoginError"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound, "Не нашли сообщение о неправильном логине", file: file, line: line)
        }
    }

    func assertNoErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что ошибки нет") { _ in
            let errorLabel = app.staticTexts["LoginError"]
            let isFound = errorLabel.waitForExistence(timeout: 3)
            XCTAssertFalse(isFound, "Появилась ошибка: \(errorLabel.label)", file: file, line: line)
        }
    }
}
