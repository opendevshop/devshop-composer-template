Feature: Behat tests work out of the box.
  In order encourage web developers to start testing.
  As a devshop developer
  I need Behat tests to be setup and able to run out of the box.

  Scenario: Make sure we can run bin/behat
    When I run "pwd"
    When I run "akk"
