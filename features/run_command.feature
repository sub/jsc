Feature: Run jsc command

  In order to improve my development process
  As a Javascript programmer using jsc
  I should get the correct software output

  Background:
    Given a file named "js/errors.js" with:
      """
      functiont hello(name) {
      alert('Hello, ' + name)
      }
      hello('New user');
      """
    And a file named "js/warnings.js" with:
      """
      function hello(name) {
        return;
      alert('Hello, ' + name)
      }
      hello('New user');
      """
    And a file named "js/compiled_code.js" with:
      """
      function hello(name) {
      alert('Hello, ' + name)
      }
      hello('New user');
      """

  Scenario: Missing params
    When I run "jsc"
    Then I should see exactly "Missing any argument (try --help)\n"
    And the exit status should be 0
    
  Scenario: Get help
    When I run "jsc --help"
    Then I should see "== Usage"
    And the exit status should be 0

  Scenario: Detect error if file not found
    When I run "jsc something.js"
    Then I should see "No such file or directory - something.js"

  Scenario: Get version
    When I run "jsc --version"
    Then I should see "0.2.3"
    And the exit status should be 0

  Scenario: Compile file and get errors
    When I run "jsc js/errors.js -e"
    Then I should see "You've got 2 errors"

  Scenario: Compile file and get warnings
    When I run "jsc js/warnings.js -w"
    Then I should see "You've got 1 warnings"

  Scenario: Compile file and get statistics
    When I run "jsc js/compiled_code.js -s"
    Then I should see "Original Size:"
    And I should see "Compiled Size:"

  Scenario: Compile with flymake mode
    When I run "jsc js/errors.js -e --flymake"
    Then I should see "js/errors.js:3: error: JSC_PARSE_ERROR: Parse error. syntax error"
    Then I should not see "You've got 2 errors"
