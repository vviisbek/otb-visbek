require_relative '../../lib/otb/jobs_parser'

RSpec.describe Otb::Parser do

  it "should respond to method parse_jobs" do
    parser = Otb::Parser.new ""
    expect(parser).to respond_to :parse_jobs
  end

  describe "method #parse_jobs" do
    
    context "with no jobs given" do
      it "parse_jobs should return an empty hash" do
        jobs = Otb::Parser.new("").parse_jobs
        expect(jobs).to be_empty
      end
    end

    context "with 2 jobs given and 0 dependencies" do
      it "parse_jobs should return a hash that includes 2 jobs" do
        jobs = Otb::Parser.new("a => \nb => ").parse_jobs
        expect(jobs.size).to eq 2
      end
    end

    context "with 2 jobs given and 1 dependency" do
      it "parse_jobs should return a hash that includes 2 jobs" do
        jobs = Otb::Parser.new("a => \nb => c").parse_jobs
        expect(jobs.size).to eq 2
      end
    end

    context "jobs that DO NOT have dependencies" do
      it "parse_jobs should return a hash with keys as jobs where values are empty strings" do
      	jobs = Otb::Parser.new("o => \nt => \nb => ").parse_jobs
      	expect(jobs).to eq({'o' => '', 't' => '', 'b' => ''})
      end
    end

    context "jobs that DO have dependencies" do
      it "parse_jobs should return a hash with keys as jobs where values are dependencies" do
      	jobs = Otb::Parser.new("o => a\nt => o\nb => t").parse_jobs
      	expect(jobs).to eq({'o' => 'a', 't' => 'o', 'b' => 't'})
      end
    end
    
    context "jobs that DO have SOME dependencies" do
      it "parse_jobs should return a hash with keys as jobs where values are empty strings or dependencies" do
      	jobs = Otb::Parser.new("o => a\nt => \nb => t").parse_jobs
      	expect(jobs).to eq({'o' => 'a', 't' => '', 'b' => 't'})
      end
    end

  end

end