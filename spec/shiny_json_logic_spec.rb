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
        [
          {"map" => [{"var" => "integers"}, {"*" => [{"var" => ""},2]}]},
          {"integers" => [1,2,3]},
          [2,4,6]
        ],
        [
          {"map" => [{"var" => "integers"}, {"*" => [{"var" => ""},2]}]},
          nil,
          []
        ],
        [
          {"map" => [{"var" => "desserts"}, {"var" => "qty"}]},
          {"desserts" => [
            {"name" => "apple","qty" => 1},
            {"name" => "brownie","qty" => 2},
            {"name" => "cupcake","qty" => 3}
          ]},
          [1,2,3]
        ],
      ].each_with_index do |testcase, index|
        describe "example ##{index}: #{testcase}" do
          it "works" do
            expect(described_class.apply(*testcase[0..1])).to eq(testcase.last)
          end
        end
      end
    end
  end

  ifs = [
    [{"if"=>[]}, nil, nil],
    [{"if"=>[true]}, nil, true],
    [{"if"=>[false]}, nil, false],
    [{"if"=>["apple"]}, nil, "apple"],
    [{"if"=>[true, "apple"]}, nil, "apple"],
    [{"if"=>[false, "apple"]}, nil, nil],
    [{"if"=>[true, "apple", "banana"]}, nil, "apple"],
    [{"if"=>[false, "apple", "banana"]}, nil, "banana"],
    [{"if"=>[ [], "apple", "banana"]}, nil, "banana"],
    [{"if"=>[ [1], "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ [1,2,3,4], "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ "", "apple", "banana"]}, nil, "banana"],
    [{"if"=>[ "zucchini", "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ "0", "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ {"+"=>"0"}, "apple", "banana"]}, nil, "banana"],
    [{"if"=>[ {"+"=>"1"}, "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ 0, "apple", "banana"]}, nil, "banana"],
    [{"if"=>[ 1, "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ 3.1416, "apple", "banana"]}, nil, "apple"],
    [{"if"=>[ -1, "apple", "banana"]}, nil, "apple"],
    [{"if" => [ {">" => [2,1]}, "apple", "banana"]}, nil, "apple"],
    [{"if" => [ {">" => [1,2]}, "apple", "banana"]}, nil, "banana"],
    [{"if" => [ true, {"cat" => ["ap","ple"]}, {"cat" => ["ba","na","na"]} ]}, nil, "apple"],
    [{"if" => [ false, {"cat" => ["ap","ple"]}, {"cat" => ["ba","na","na"]} ]}, nil, "banana"],
    [{"if" => [true, "apple", true, "banana"]}, nil, "apple"],
    [{"if" => [true, "apple", false, "banana"]}, nil, "apple"],
    [{"if" => [false, "apple", true, "banana"]}, nil, "banana"],
    [{"if" => [false, "apple", false, "banana"]}, nil, nil],
    [{"if" => [true, "apple", true, "banana", "carrot"]}, nil, "apple"],
    [{"if" => [true, "apple", false, "banana", "carrot"]}, nil, "apple"],
    [{"if" => [false, "apple", true, "banana", "carrot"]}, nil, "banana"],
    [{"if" => [false, "apple", false, "banana", "carrot"]}, nil, "carrot"],
    [{"if" => [false, "apple", false, "banana", false, "carrot"]}, nil, nil],
    [{"if" => [false, "apple", false, "banana", false, "carrot", "date"]}, nil, "date"],
    [{"if" => [false, "apple", false, "banana", true, "carrot", "date"]}, nil, "carrot"],
    [{"if" => [false, "apple", true, "banana", false, "carrot", "date"]}, nil, "banana"],
    [{"if" => [false, "apple", true, "banana", true, "carrot", "date"]}, nil, "banana"],
    [{"if" => [true, "apple", false, "banana", false, "carrot", "date"]}, nil, "apple"],
    [{"if" => [true, "apple", false, "banana", true, "carrot", "date"]}, nil, "apple"],
    [{"if" => [true, "apple", true, "banana", false, "carrot", "date"]}, nil, "apple"],
    [{"if" => [true, "apple", true, "banana", true, "carrot", "date"]}, nil, "apple"],
    [{"if" => [{"var" => "x"}, [{"var" => "y"}], 99]}, {"x" => true, "y" => 42}, [42]],
  ]
end
