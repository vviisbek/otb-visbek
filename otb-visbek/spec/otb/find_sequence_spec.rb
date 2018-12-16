require_relative '../../lib/otb/find_sequence'
require_relative '../../lib/otb/jobs_parser'

RSpec.describe Otb::FindSequence do

  it "should respond to method order_jobs" do
  	parser = Otb::Parser.new("")
    sequence = Otb::FindSequence.new(parser)
    expect(sequence).to respond_to :order_jobs
  end
  

  describe "with no jobs given" do
  	it "should return an empty string" do
      parser = Otb::Parser.new("")
      sequence = Otb::FindSequence.new(parser)
      expect(sequence.order_jobs).to be_empty
    end 
  end


  describe "with a single job without dependency" do
  	it "should return a sequence consisting of a single job a" do
  	  parser = Otb::Parser.new("a => ")
  	  sequence = Otb::FindSequence.new(parser)
  	  expect(sequence.order_jobs).to eq "a"
  	end
  end


  describe "with three jobs and without dependencies" do
  	it "should return a sequence containing all three jobs in no significant order" do
      parser = Otb::Parser.new("o => \nt => \nb => ")
      sequence = Otb::FindSequence.new(parser)
      expect(sequence.order_jobs).to eq "otb"
    end
  end

  describe "given job structure (a => , b => c, c =>)" do
  	before :all do
  	  parser = Otb::Parser.new("a => \nb => c\nc => ")
      sequence = Otb::FindSequence.new(parser)
      @jobs_ordered = sequence.order_jobs
    end

  	it "should return a sequence containing all three jobs a, b, c" do
      expect(@jobs_ordered).to include("a", "b", "c")
    end

    it "should return a sequence that positions c before b" do
      expect(@jobs_ordered).to match "cb"
    end
  end

  describe "given job structure (a => , b => c, c => f, d => a, e => b, f => )" do
  	before :all do
  	  parser = Otb::Parser.new("a => \nb => c\nc => f\nd => a\ne => b\nf => ")
      sequence = Otb::FindSequence.new(parser)
      @jobs_ordered = sequence.order_jobs
    end

  	it "should return a sequence containing all six jobs a, b, c, d, e, f" do
      expect(@jobs_ordered).to include("a", "b", "c", "d", "e", "f")
    end

    it "should return a sequence that positions c before b" do
      expect(@jobs_ordered).to match "cb"
    end

    it "should return a sequence that positions f before c" do
      expect(@jobs_ordered).to match "fc"
    end

    it "should return a sequence that positions a before d" do
      expect(@jobs_ordered).to match "ad"
    end

    it "should return a sequence that positions b before e" do
      expect(@jobs_ordered).to match "be"
    end
  end

  describe "given job structure (a => , b => , c => c)" do
    it "should raise 'jobs can’t depend on themselves'" do
      parser = Otb::Parser.new("a => \nb => \nc => c")
      sequence = Otb::FindSequence.new(parser)
      expect{sequence.order_jobs}.to raise_error("Error: jobs can’t depend on themselves")
    end
  end

  describe "given job structure (a => , b => c, c => f, d => a, e => , f => b)" do
    it "should raise 'jobs have circular dependencies'" do
      parser = Otb::Parser.new("a => \nb => c\nc => f\nd => a\ne => \nf => b")
      sequence = Otb::FindSequence.new(parser)
      expect{sequence.order_jobs}.to raise_error("Error: jobs have circular dependencies")
    end
  end

end
