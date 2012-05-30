#encoding:utf-8
Given /^I am on merit view$/ do
  navigate_to_merit_view
end

When /^I add "(.*?)" point to behavior "(.*?)"$/ do |score, behavior|
  # context[:merit] = current_merit behavior
  text_field_selector =  "view marked:'#{behavior}'" 
  swipeIndDirection("view marked:'#{behavior}'", 'right')
  sleep 1
end

Then /^I can see "(.*?)" score increased "(.*?)"$/ do |behavior, score|
  text_field_selector = "view marked:'#{behavior}:1'" 
  check_element_exists(text_field_selector)
end