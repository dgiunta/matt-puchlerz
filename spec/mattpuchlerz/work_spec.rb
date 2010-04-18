require File.join( File.dirname(__FILE__), *%w[ .. spec_helper ] )

describe MattPuchlerz::Work do
  
  before :each do
    MattPuchlerz::Work.send :class_variable_set, '@@instances', []
  end
  
  context "class behavior" do
    
    it "finds all works within memory" do
      MattPuchlerz::Work.send :class_variable_set, '@@instances', [ :one, :two, :three ]
      MattPuchlerz::Work.all.should == [ :one, :two, :three ]
    end
    
    it "creates works" do
      work = MattPuchlerz::Work.create :slug => 'slug',
                                       :title => 'Title',
                                       :description => 'Description'
      
      work.should be_instance_of(MattPuchlerz::Work)
      MattPuchlerz::Work.all.should == [ work ]
    end
    
    it "finds viewable works" do
      MattPuchlerz::Work.make
      MattPuchlerz::Work.make
      MattPuchlerz::Work.make :slug => 'there is no way that this could be a valid slug'
      MattPuchlerz::Work.viewable.length.should == 2
    end
    
    it "finds the first work" do
      work1 = MattPuchlerz::Work.make
      work2 = MattPuchlerz::Work.make
      MattPuchlerz::Work.first.should == work1
    end
    
    it "finds the first work that matches the slug passed" do
      work1 = MattPuchlerz::Work.make :slug => 'work1'
      work2 = MattPuchlerz::Work.make :slug => 'work2'
      MattPuchlerz::Work.first(:slug => 'work2').should == work2
    end
      
  end
  
  context "instance behavior" do
    
    context "when saving" do
      
      it "should save" do
        work = MattPuchlerz::Work.new 
        work.save
        MattPuchlerz::Work.all.should include(work)
      end
      
    end
    
    context "when initialized with no attributes" do

      before :each do
        @work = MattPuchlerz::Work.new
      end

      it "should have 0 images" do
        @work.should have(0).images
      end

      it "should not be viewable" do
        @work.should_not be_viewable
      end

    end

    context "when initialized with attributes" do
      
      it "should set attributes passed in via a hash" do
        @work = MattPuchlerz::Work.new :slug => 'slug', 
                                       :title => 'Title', 
                                       :description => 'Description'
                                       
        @work.slug.should == 'slug'
        @work.title.should == 'Title'
        @work.description.should == 'Description'
      end
      
    end
    
    context "when setting attributes of the work" do

      before :each do
        @work = MattPuchlerz::Work.new
      end

      it "should be able to set a title" do
        @work.title = 'I am the title'
        @work.title.should == 'I am the title'
      end

      it "should be able to set a description" do
        @work.description = 'I am the description'
        @work.description.should == 'I am the description'
      end
      
      it "should be able to set a slug, which converts/strips any non-alphanumerics, underscores, or hyphens" do
        @work.slug = %Q{ Who do I 'look' like 2-U, an "awesome" slug!? }
        @work.slug.should == 'who_do_i_look_like_2-u_an_awesome_slug'
      end

      it "should be able to find images after setting the slug" do
        @work.slug = 'test1'
        @work.images.should == [ 
          '/images/works/test1/Avatar.png', 
          '/images/works/test1/ScreenClean.jpg', 
          '/images/works/test1/The+Optical+Illusion+Kid.gif' 
        ]
      end

      it "should cache the images after finding them on the first call" do
        Dir.should_receive(:glob).once.and_return([
          '/Users/mattpuchlerz/Sites/matt.puchlerz.com/public/images/works/test1/Avatar.png',
          '/Users/mattpuchlerz/Sites/matt.puchlerz.com/public/images/works/test1/ScreenClean.jpg',
          '/Users/mattpuchlerz/Sites/matt.puchlerz.com/public/images/works/test1/The Optical Illusion Kid.gif',
        ])
        
        @work.slug = 'test1'
        @work.images
        @work.images.should == [ 
          '/images/works/test1/Avatar.png', 
          '/images/works/test1/ScreenClean.jpg', 
          '/images/works/test1/The+Optical+Illusion+Kid.gif' 
        ]
      end

      it "should be able to find the thumbnail image after setting the slug" do
        @work.slug = 'test1'
        @work.image_thumbnail.should == '/images/works/test1/_thumb.png'
      end

    end
    
    context "functioning as a list" do
      
      it "should find the next viewable work" do
        work1 = MattPuchlerz::Work.make
        work2 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 1'
        work3 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 2'
        work4 = MattPuchlerz::Work.make
        work1.next_item.should == work4
      end

      it "should still return nil if there are no proceeding viewable works" do
        work1 = MattPuchlerz::Work.make
        work2 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 1'
        work3 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 2'
        work1.next_item.should == nil
      end

      it "should find the previous viewable work" do
        work1 = MattPuchlerz::Work.make
        work2 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 1'
        work3 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 2'
        work4 = MattPuchlerz::Work.make
        work4.previous_item.should == work1
      end

      it "should still return nil if there are no proceeding viewable works" do
        work1 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 1'
        work2 = MattPuchlerz::Work.make :slug => 'no way that this will be a valid slug 2'
        work3 = MattPuchlerz::Work.make
        work3.previous_item.should == nil
      end

    end

    context "determining readiness for viewing" do
      
      it "should not be viewable when its slug is blank" do
        work = MattPuchlerz::Work.make :slug => ''
        work.should_not be_viewable
      end

      it "should not be viewable when its title is blank" do
        work = MattPuchlerz::Work.make :title => ''
        work.should_not be_viewable
      end

      it "should not be viewable when its description is blank" do
        work = MattPuchlerz::Work.make :description => ''
        work.should_not be_viewable
      end

      it "should not be viewable when it has 0 images" do
        work = MattPuchlerz::Work.make
        work.should_receive(:images).and_return(nil)
        work.should_not be_viewable
      end

      it "should not be viewable when it has no thumbnail image" do
        work = MattPuchlerz::Work.make
        work.should_receive(:image_thumbnail).and_return(nil)
        work.should_not be_viewable
      end

      it "should be viewable when it has a slug, title, description, and 1 or more images" do
        work = MattPuchlerz::Work.make
        work.should be_viewable
      end

    end
    
  end
  
end