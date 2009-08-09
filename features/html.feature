Feature: HTML
  In order for the website to render correctly
  As a developer
  I want the required HTML markup to be in the response

  Scenario: Required HTML tags
    Given I am on the home page
    Then I should see the following tags:
      | tag   |
      | html  |
      | head  |
      | title |
      | body  |

  Scenario: Default page title
    Given I am on the home page
    Then the title should be "Matt Puchlerz — Designer & Web Developer"
  
  
  