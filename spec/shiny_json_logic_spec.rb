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
        [ {"-"=>[2,3]}, {}, -1 ],
        [ {"-"=>[3,2]}, {}, 1 ],
        [ {"-"=>[3]}, {}, -3 ],
        [ {"-"=>["1",1]}, {}, 0 ],
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
