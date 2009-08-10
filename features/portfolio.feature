Feature: Portfolio
  In order to exemplify my skills and proven track-record
  As a designer and developer
  I want to display selected works
  
  Scenario: Accessing the works index page
    Given I am a user
    And I am on the home page
    When I follow "Works"
    Then I should be on the works index page
    
  Scenario: Viewing a listing of completed works
    Given the following works exist:
      | title           | slug            | description                                              |
      | Awesome Work    | test1           | This was something I did back when I was awesome.        |
      | Untitled        | test2           | Never was sure what to call this one.                    |
      | $%*!            | test3           | If you've got nothing good to say...                     |
      | Unviewable Work | unviewable_work | As this work wont have images, it should not be viewable |
    And I am a user
    And I am on the works index page
    Then I should see "Works"
    And I should see the following works:
      | title           | slug            | description                                              |
      | Awesome Work    | test1           | This was something I did back when I was awesome.        |
      | Untitled        | test2           | Never was sure what to call this one.                    |
      | $%*!            | test3           | If you’ve got nothing good to say…                       |
	And I should not see the following works:
      | title           | slug            | description                                              |
	  | Unviewable Work | unviewable_work | As this work wont have images, it should not be viewable |
      
  Scenario: Accessing the work details page
    Given the following works exist:
      | title        | slug  | description                                       |
      | Awesome Work | test2 | This was something I did back when I was awesome. |
    And I am a user
    And I am on the works index page
    When I follow "Awesome Work"
    Then I should be on the work show page

  @current
  Scenario: Viewing the details of a single work
    Given the following works exist:
      | title         | slug  | description                                       |
      | Awesome Title | test2 | This was something I did back when I was awesome. |
    And I am a user
    And I am on the work show page
    Then the title should be "Awesome Title — A Work by Matt Puchlerz"
    Then I should see the following:
      | elements                                          |
      | Awesome Title                                     |
      | This was something I did back when I was awesome. |
      # | one of more images of the work     |
