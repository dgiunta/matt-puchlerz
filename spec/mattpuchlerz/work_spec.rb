require File.join( File.dirname(__FILE__), *%w[ .. spec_helper ] )

describe MattPuchlerz::Work do
  
  context "class behavior" do
    
    context "setting up" do
      
      it "should have a #viewable method" do
        MattPuchlerz::Work.should respond_to(:viewable)
      end
      
    end
    
    context "finding works" do
      
      before :all do
        @work1 = MattPuchlerz::Work.make
        @work2 = MattPuchlerz::Work.make
        @work3 = MattPuchlerz::Work.make :slug => 'no way that this is going to exist or be viewable'
      end
      
      it "should be able to find viewable works" do
        MattPuchlerz::Work.viewable.length.should == 2
      end
      
    end
    
  end
  
  context "instance behavior" do
    
    context "when initialized" do

      before :each do
        @work = MattPuchlerz::Work.new
      end

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
      
      it "should have a #image_thumbnail method" do
        @work.should respond_to(:image_thumbnail)
      end
      
      it "should have a #position method" do
        @work.should respond_to(:position)
      end

      it "should have a #move method" do
        @work.should respond_to(:move)
      end

      it "should have 0 images" do
        @work.should have(0).images
      end

      it "should not be viewable" do
        @work.should_not be_viewable
      end

    end

    context "when setting attributes of the work" do

      before :each do
        @work = MattPuchlerz::Work.new
      end

      it "should be able to set a slug, which converts/strips any non-alphanumerics, underscores, or hyphens" do
        @work.slug = %Q{ Who do I 'look' like 2-U, an "awesome" slug!? }
        @work.slug.should == 'who_do_i_look_like_2-u_an_awesome_slug'
      end

      it "should be able to find images after setting the slug" do
        @work.slug = "test1"
        @work.images.should == [ 
          '/images/works/test1/Avatar.png', 
          '/images/works/test1/ScreenClean.jpg', 
          '/images/works/test1/The+Optical+Illusion+Kid.gif' 
        ]
      end

      it "should be able to find the thumbnail image after setting the slug" do
        @work.slug = "test1"
        @work.image_thumbnail.should == '/images/works/test1/_thumb.png'
      end

      it "should be able to set a title" do
        @work.title = 'I am the title'
        @work.title.should == 'I am the title'
      end

      it "should be able to set a description" do
        @work.description = 'I am the description'
        @work.description.should == 'I am the description'
      end
      
      it "should be able to move its position within the list" do
        work1 = MattPuchlerz::Work.make
        work2 = MattPuchlerz::Work.make
        work1.position.should < work2.position

        work1.move(:down)
        work2.reload
        work1.position.should > work2.position
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
        pending
        work = MattPuchlerz::Work.make
        work.should_recieve(:image_thumbnail).and_return(nil)
        work.should_not be_viewable
      end

      it "should be viewable when it has a slug, title, description, and 1 or more images" do
        work = MattPuchlerz::Work.make
        work.should be_viewable
      end

    end
    
  end
  
end