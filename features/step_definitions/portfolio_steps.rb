Given /^the following works exist:$/ do |table|
  table.hashes.each do |attributes|
    work = MattPuchlerz::Work.new attributes
    work.save
  end
end

When /^I press "([^\"]*)" of a specific work$/ do |element|
  pending
end

Then /^I (should|should not) see the following works:$/ do |boolean, table|
  table.hashes.each do |attributes|
    Then %Q{I #{ boolean } see "#{ attributes['title'] }"}
    # Then %Q{I should see "#{ attributes['slug'] }"}
    Then %Q{I #{ boolean } see "#{ attributes['description'] }"}
  end
end