require 'json'

RSpec.describe ShinyJsonLogic do
  cases =  begin
             JSON.parse(open('https://jsonlogic.com/tests.json').read)
           rescue Errno::ENOENT
             JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures/tests.json')))
           end

  it "has a version number" do
    expect(ShinyJsonLogic::VERSION).not_to be nil
  end

  describe "standard behavior" do
    let(:cases) do
      JSON.parse(open('https://jsonlogic.com/tests.json').read)
    rescue Errno::ENOENT
      JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures/tests.json')))
    end

    cases.each_with_index do |testcase, index|
      next unless testcase.is_a?(Array)

      describe "example ##{index}: #{testcase}" do
        it "works" do
          expect(described_class.apply(*testcase[0..1])).to eq(testcase.last)
        end
      end
    end

    describe "lolo", skip: false do
      [
        # [{"if"=>[]}, nil, nil],
        # [{"if"=>[true]}, nil, true],
        # [{"if"=>[false]}, nil, false],
        # [{"if"=>["apple"]}, nil, "apple"],
        # [{"if"=>[true, "apple"]}, nil, "apple"],
        # [{"if"=>[false, "apple"]}, nil, nil],
        # [{"if"=>[true, "apple", "banana"]}, nil, "apple"],
        # [{"if"=>[false, "apple", "banana"]}, nil, "banana"],
        # [{"if"=>[ [], "apple", "banana"]}, nil, "banana"],
        # [{"if"=>[ [1], "apple", "banana"]}, nil, "apple"],
        # [{"if"=>[ [1,2,3,4], "apple", "banana"]}, nil, "apple"],
        # [{"if"=>[ "", "apple", "banana"]}, nil, "banana"],
        # [{"if"=>[ "zucchini", "apple", "banana"]}, nil, "apple"],
        # [{"if"=>[ "0", "apple", "banana"]}, nil, "apple"],
        # [{"==="=>[0,"0"]}, nil, false],
        [{"==="=>[0,{"+"=>"0"}]}, nil, true],
      ].each_with_index do |testcase, index|
        describe "example ##{index}: #{testcase}" do
          it "works" do
            expect(described_class.apply(*testcase[0..1])).to eq(testcase.last)
          end
        end
      end
    end
  end
end
