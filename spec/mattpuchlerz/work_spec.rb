require File.join( File.dirname(__FILE__), *%w[ .. spec_helper ] )

describe MattPuchlerz::Work do
  
  before(:each) do
    @work = MattPuchlerz::Work.new
  end
  
  context "when initialized" do
    
    it "should have an #id method" do
      @work.should respond_to(:id)
    end
    
    it "should have #slug method" do
      @work.should respond_to(:slug)
    end
    
    it "should have a #title method" do
      @work.should respond_to(:title)
    end
    
    it "should have a #description method" do
      @work.should respond_to(:description)
    end
    
    it "should have an #images method" do
      @work.should respond_to(:images)
    end
    
    it "should have 0 images" do
      @work.should have(0).images
    end
    
    it "should not be viewable" do
      @work.should_not be_viewable
    end
    
  end
  
  context "when setting attributes of the work" do
    
    it "should be able to set a slug, which converts/strips any non-alphanumerics, underscores, or hyphens" do
      @work.slug = %Q{ Who do I 'look' like 2-U, an "awesome" slug!? }
      @work.slug.should == 'who_do_i_look_like_2-u_an_awesome_slug'
    end
    
    it "should be able to find images after setting the slug" do
      @work.slug = "test_slug"
      @work.images.should == [ 'Avatar.png', 'ScreenClean.jpg', 'The Optical Illusion Kid.gif' ]
    end
    
    it "should be able to set a title" do
      @work.title = 'I am the title'
      @work.title.should == 'I am the title'
    end
    
    it "should be able to set a description" do
      @work.description = 'I am the description'
      @work.description.should == 'I am the description'
    end
    
  end
  
  context "determining readiness for viewing" do
    
    it "should not be viewable when its slug is blank" do
      @work.slug = ''
      @work.title = 'This is the title.'
      @work.description = 'This is the description.'
      @work.should_not be_viewable
    end
    
    it "should not be viewable when its title is blank" do
      @work.slug = 'test_slug'
      @work.title = ''
      @work.description = 'This is the description.'
      @work.should_not be_viewable
    end
    
    it "should not be viewable when its description is blank" do
      @work.slug = 'test_slug'
      @work.title = 'This is the title.'
      @work.description = ''
      @work.should_not be_viewable
    end
    
    it "should not be viewable when it has 0 images" do
      @work.slug = 'There is no way that the work will have any images under this slug'
      @work.title = 'This is the title.'
      @work.description = 'This is the description.'
      @work.should_not be_viewable
    end
    
    it "should be viewable when it has a slug, title, description, and 1 or more images" do
      @work.slug = 'test_slug'
      @work.title = 'This is the title.'
      @work.description = 'This is the description.'
      @work.should be_viewable
    end
    
  end
      
end