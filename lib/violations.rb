require 'csv'
require 'time'

class Violations
  def initialize(filename)
    @violations = []
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |violation|
      formatted = violation.to_h
      formatted[:violation_id] = violation[:violation_id].to_i
      formatted[:inspection_id] = violation[:inspection_id].to_i
      formatted[:violation_date] = Time.parse(violation[:violation_date]) if violation[:violation_date]
      formatted[:violation_date_closed] = Time.parse(violation[:violation_date_closed]) if violation[:violation_date_closed]
      @violations.push(formatted)
    end

    @violations.sort! do |a, b|
      a[:violation_date] <=> b[:violation_date]
    end
  end

  def length
    @violations.length
  end

  def earliest
    @violations.first
  end

  def latest_by_type
    violations = {}

    @violations.each do |violation|
      violations[violation[:violation_type]] ||= violation
      if violations[violation[:violation_type]][:violation_date] < violation[:violation_date]
        violations[violation[:violation_type]] = violation
      end
    end

    violations
  end

  def self.load(filename)
    new(filename)
  end
end