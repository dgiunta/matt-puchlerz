Sham.description  { Faker::Lorem.paragraphs }
Sham.slug         { |i| "test#{i}" }
Sham.title        { Faker::Lorem.words(5).join }

MattPuchlerz::Work.blueprint do
  description
  slug
  title
end