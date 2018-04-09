require './lib/violations'
require 'time'

RSpec.describe 'Violations' do
  it 'should be able to load in the CSV of violations' do
    violations = Violations.load('./data/violations.5.csv')

    expect(violations.length).to be(5)

    violations = Violations.load('./data/violations.10.csv')

    expect(violations.length).to be(10)
  end

  it 'should be able to get the earliest violation' do
    violations = Violations.load('./data/violations.5.csv')

    expected = {
      violation_id: 204851,
      inspection_id: 261019,
      violation_category: 'Garbage and Refuse',
      violation_date: Time.parse('2012-01-02 00:00:00'),
      violation_date_closed: Time.parse('2012-02-02 00:00:00'),
      violation_type: 'Refuse Accumulation'
    }

    expect(violations.earliest).to eq(expected)
  end

  it 'should be able to get the earliest violation of each type' do
    expected = {
      'Refuse Accumulation' => 204853,
      'Inadequate Pest Exclusion' => 204854,
      'Overgrown Vegetation' => 204859
    }

    violations = Violations.load('./data/violations.5.csv')
    result = violations.latest_by_type

    expect(result.length).to be > 0
    result.each do |key, violation|
      expect(expected).to have_key(violation[:violation_type])
      expected_id = expected[violation[:violation_type]]
      expect(violation[:violation_id]).to eq(expected_id)
    end
  end
end