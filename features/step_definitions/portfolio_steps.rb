Given /^the following works exist:$/ do |table|
  table.hashes.each do |row|
    work = MattPuchlerz::Work.new row
    work.save
  end
end

When /^I press "([^\"]*)" of a specific work$/ do |element|
  pending
end

Then /^I (should|should not) see the following works:$/ do |boolean, table|
  table.hashes.each do |row|
    Then %Q{I #{ boolean } see "#{ row['title'] }"}
    # Then %Q{I should see "#{ row['slug'] }"}
    Then %Q{I #{ boolean } see "#{ row['description'] }"}
  end
end