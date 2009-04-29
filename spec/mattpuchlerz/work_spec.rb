require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe MattPuchlerz::Work do
  
  before(:each) do
    @work = MattPuchlerz::Work.new
  end
  
  context "when initialized" do
    
    it "should have a title method" do
      @work.should respond_to(:title)
    end
    
    it "should have a description method" do
      @work.should respond_to(:description)
    end
    
    it "should have an images method" do
      @work.should respond_to(:images)
    end
    
    it "should have 0 images" do
      @work.should have(0).images
    end
    
    it "should not be viewable" do
      @work.should_not be_viewable
    end
    
  end
  
  context "when setting the work's values" do
    
    it "should be able to set a title" do
      @work.title = 'I am the title'
      @work.title.should == 'I am the title'
    end
    
    it "should be able to set a description" do
      @work.description = 'I am the description'
      @work.description.should == 'I am the description'
    end
    
    it "should be able to add images" do
      @work.images << 'image1.jpg'
      @work.images << 'image2.jpg'
      @work.images.should == [ 'image1.jpg', 'image2.jpg' ]
    end
    
  end
  
  context "automatically setting attributes via options passed during initialization" do
    
    it "should set the title when passing in a title" do
      @work = MattPuchlerz::Work.new :title => 'I am the title'
      @work.title.should == 'I am the title'
    end
    
    it "should set the description when passing in a description" do
      @work = MattPuchlerz::Work.new :description => 'I am the description'
      @work.description.should == 'I am the description'
    end
    
    it "should set the images when passing in images" do
      @work = MattPuchlerz::Work.new :images => ['image1.jpg', 'image2.jpg']
      @work.images.should == ['image1.jpg', 'image2.jpg']
    end
    
  end
  
  context "determining readiness for viewing" do
    
    it "should not be viewable when it is missing a title" do
      @work.description = 'This is the description.'
      @work.images << 'image1.jpg'
      @work.should_not be_viewable
    end
    
    it "should not be viewable when it is missing a description" do
      @work.title = 'This is the title.'
      @work.images << 'image1.jpg'
      @work.should_not be_viewable
    end
    
    it "should not be viewable when it has 0 images" do
      @work.title = 'This is the title.'
      @work.description = 'This is the description.'
      @work.should_not be_viewable
    end
    
    it "should be viewable when it has a title, description, and 1 or more images" do
      @work.title = 'This is the title.'
      @work.description = 'This is the description.'
      @work.images << 'image1.jpg'
      @work.should be_viewable
    end
    
  end
      
end