Given /^the following works exist:$/ do |table|
  table.hashes.each do |row|
    work = MattPuchlerz::Work.new row
    work.save
  end
end

When /^I press "([^\"]*)" of a specific work$/ do |element|
  pending
end