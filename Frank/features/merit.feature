@wip
Feature: 
  As an user
  I want to record my merit
  So I can see if I do something good

Scenario: add merit in merit view
  Given I am on merit view
  When I add "1" point to behavior "赞一人善"
  Then I can see "赞一人善" score increased "1" 