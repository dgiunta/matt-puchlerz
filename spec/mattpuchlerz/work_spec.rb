require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe MattPuchlerz::Work do
  
  context "when initialized" do
    
    before(:each) do
      @work = MattPuchlerz::Work.new
    end
    
    it "should have a title method" do
      @work.should respond_to(:title)
    end
    
    it "should have a description method" do
      @work.should respond_to(:description)
    end
    
    it "should have an images method" do
      @work.should respond_to(:images)
    end
    
  end
  
end