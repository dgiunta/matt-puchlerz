Feature: Portfolio
  In order to exemplify my skills and proven track-record
  As a designer and developer
  I want to display selected works
  
  @current
  Scenario: Accessing the portfolio page
    Given I am a user
      And I am on the home page
    When I follow "Works"
    Then I should be on the portfolio page
    
  Scenario Outline: Viewing a listing of completed works
    Given I am a user
      And I am on the portfolio page
    When the page loads
    Then I should see "<elements>"
    
    Examples:
    | elements                        |
    | several completed works         |
    | a title for each work           |
    | a thumbnail image for each work |
      
  Scenario Outline: Accessing the work details page
    Given I am a user
      And I am on the portfolio page
    When I press "<elements>" of a specific work
    Then I should be on work details
  
    Examples:
    | elements            |
    | the title           |
    | the thumbnail image |

  Scenario Outline: Viewing the details of a single work
    Given I am a user
      And I am on the work details page
    When the page loads
    Then I should see "<elements>"
    
    Examples:
    | elements                           |
    | the title of the work              |
    | the description of the work        |
    | one of more images of the work     |
    | one or more tags labeling the work |
  
  