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

      describe "example ##{index + 1}: #{testcase}" do
        it "works" do
          expect(described_class.apply(*testcase[0..1])).to eq(testcase.last)
        end
      end
    end

    describe "lolo" do
      it "works" do
        rule = {"var"=>"1"},
        data = ["apple", "banana"]
        expect(described_class.apply(rule, data)).to eq("banana")
      end
    end
  end
end
