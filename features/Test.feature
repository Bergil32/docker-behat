@javascript
Feature: Open Wikipedia website
  In order to know something new
  As a internet user
  I need to be able to open Wikipedia website

  Scenario: Success
    Given I am on the homepage
    And I follow "Wikipedia"

  Scenario: Failed
    Given I am on the homepage
    And I follow "Some_strange_long_string"
