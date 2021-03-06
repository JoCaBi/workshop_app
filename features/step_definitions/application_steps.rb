And(/^I click "([^"]*)" link$/) do |element|
  click_link_or_button element
end

Then(/^a new "([^"]*)" should be created$/) do |model|
  expect(Object.const_get(model).count).to eq 1
end

Given(/^I am a registered user$/) do
  steps %q(
    Given I am on the home page
    And I click "Register" link
    Then I should be on Registration page
    And I fill in "Name" with "Thomas"
    And I fill in "Email" with "thomas@random.com"
    And I fill in "Password" with "my_password"
    And I fill in "Password confirmation" with "my_password"
    And I click "Create" link
  )
end

Given(/^I am a registered and logged in user$/) do
  steps %{
  Given I am a registered user
  And I am on the home page
  And I click "Log in" link
  Then I should be on Log in page
  And I fill in "Email" with "thomas@random.com"
  And I fill in "Password" with "my_password"
  And I click "Submit" link
        }
end

Given(/^the course "([^"]*)" is created$/) do |name|
  steps %Q{
  Given I am on the home page
  And I am a registered and logged in user
  And I click "All courses" link
  And I click "Create course" link
  And I fill in "Course Title" with "#{name}"
  And I fill in "Course description" with "Your first step into the world of programming"
  And I click "Create" link
        }
end

Given(/^the delivery for the course "([^"]*)" is set to "([^"]*)"$/) do |name, date|
  steps %Q{
  Given the course "#{name}" is created
  And I am on the Course index page
  And I click on "Add Delivery date" for the "#{name}" Course
  And I fill in "Start" with "#{date}"
  And I click "Submit" link
        }
end

And(/^I click on "([^"]*)" for the "([^"]*)" ([^"]*)$/) do |element, name, model|
  object = Object.const_get(model).find(name: name).first
  find("#course-#{object.id}").click_link(element)
end
When(/^I select the "([^"]*)" file$/) do |file_name|
  attach_file('file', File.absolute_path("./features/fixtures/#{file_name}"))
end

Then(/^([^"]*) instances of "([^"]*)" should be created$/) do |count, model|
  expect(Object.const_get(model).count).to eq count.to_i
end

And(/^the data file for "([^"]*)" is imported$/) do |date|
  steps %Q{
  And I am on the Course index page
  And I click on "#{date}" for the "Basic programming" Course
  When I select the "students.csv" file
  And I click "Submit" link
        }
end
Then(/^([^"]*) certificates should be generated$/) do |count|
  pdf_count = Dir['pdf/test/**/*.pdf'].length
  expect(pdf_count).to eq count.to_i
end


And(/^(\d+) images of certificates should be created$/) do |count|
  image_count = Dir['pdf/test/**/*.jpg'].length
  expect(image_count).to eq count.to_i
end

Given(/^valid certificates exists$/) do
  steps %q(
    Given the delivery for the course "Basic" is set to "2015-12-01"
    And the data file for "2015-12-01" is imported
    And I am on 2015-12-01 show page
    And I click "Generate certificates" link
  )
end

And(/^I visit the url for a certificate$/) do
  cert = Certificate.last
  visit "/verify/#{cert.identifier}"
end

And(/^I should see ([^"]*) "([^"]*)" links$/) do |count, element|
  expect(page).to have_link(element, count: count)
end