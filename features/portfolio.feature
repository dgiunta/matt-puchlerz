Feature: Portfolio
  In order to exemplify my skills and proven track-record
  As a designer and developer
  I want to display selected works
  
  Scenario: Accessing the portfolio page
    Given I am a user
    And I am on the home page
    When I follow "Works"
    Then I should be on the portfolio page
    
  Scenario: Viewing a listing of completed works
    Given the following works exist:
      | title        | slug         | description                                       |
      | Awesome Work | awesome_work | This was something I did back when I was awesome. |
      | Untitled     | untitled     | Never was sure what to call this one.             |
      | $%*!         | bad_word     | If you've got nothing good to say...                |
    And I am a user
    And I am on the portfolio page
    Then I should see "Works"
    And I should see the following works:
      | title        | slug         | description                                       |
      | Awesome Work | awesome_work | This was something I did back when I was awesome. |
      | Untitled     | untitled     | Never was sure what to call this one.             |
      | $%*!         | bad_word     | If you’ve got nothing good to say…                |
      
  Scenario: Accessing the work details page
    Given the following works exist:
      | title        | slug         | description                                       |
      | Awesome Work | awesome_work | This was something I did back when I was awesome. |
    And I am a user
    And I am on the portfolio page
    When I follow "Awesome Work"
    Then I should be on the work show page

  @current
  Scenario: Viewing the details of a single work
    Given the following works exist:
      | title        | slug         | description                                       |
      | Awesome Work | awesome_work | This was something I did back when I was awesome. |
    And I am a user
    And I am on the work show page
    Then I should see the following:
      | elements                                          |
      | Awesome Work                                      |
      | This was something I did back when I was awesome. |
      # | one of more images of the work     |
      # | one or more tags labeling the work |
  
  