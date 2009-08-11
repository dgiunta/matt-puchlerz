Feature: Portfolio
  In order to exemplify my skills and proven track-record
  As a designer and developer
  I want to display selected works
  
  Scenario: Accessing the works index page
    Given I am a user
    And I am on the home page
    When I follow "Works"
    Then I should be on the works index page
    
  @current
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
    And I should see the following images:
      | src                            | alt          |
      | /images/works/test1/_thumb.png | Awesome Work |
      | /images/works/test2/_thumb.jpg | Untitled     |
      | /images/works/test3/_thumb.jpg | $%*!         |
    And I should not see the following images:
      | src                                              |
      | /images/works/test1/Avatar.png                   |
      | /images/works/test1/ScreenClean.jpg              |
      | /images/works/test1/The+Optical+Illusion+Kid.gif |
      | /images/works/test2/Photo+4.jpg                  |
      | /images/works/test2/Photo+5.jpg                  |
      | /images/works/test3/Photo+372.jpg                |
      | /images/works/test3/Photo+373.jpg                |
      | /images/works/test3/Photo+374.jpg                |
  	And I should not see the following:
      | title           |
  	  | Unviewable Work |
      
  Scenario: Accessing the work details page
    Given the following works exist:
      | title        | slug  | description                                       |
      | Awesome Work | test1 | This was something I did back when I was awesome. |
    And I am a user
    And I am on the works index page
    When I follow "Awesome Work"
    Then I should be on the work show page

  Scenario: Viewing the details of a single work
    Given the following works exist:
      | title         | slug  | description                                       |
      | Awesome Title | test1 | This was something I did back when I was awesome. |
    And I am a user
    And I am on the work show page
    Then the title should be "Awesome Title — A Work by Matt Puchlerz"
    Then I should see the following:
      | elements                                          |
      | Awesome Title                                     |
      | This was something I did back when I was awesome. |
    And I should see the following images:
      | src                                              |
      | /images/works/test1/Avatar.png                   |
      | /images/works/test1/ScreenClean.jpg              |
      | /images/works/test1/The+Optical+Illusion+Kid.gif |

  Scenario: Viewing a non-viewable work
    Given the following works exist:
      | title           | slug            | description                                              |
      | Unviewable Work | unviewable_work | As this work wont have images, it should not be viewable |
    And I am a user
    And I am on the work show page
    Then I should get a 404 response code

  Scenario: Viewing a non-existent work
    Given I am a user
    And I am on the blank work show page
    Then I should get a 404 response code
