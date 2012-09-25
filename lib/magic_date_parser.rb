require 'date'
require "magic_date_parser/version"

module MagicDateParser
  def self.range(raw, backup = "")
    start, finish = try_all_formats(raw)

    backup_date = date(backup)

    start ||= backup_date
    finish ||= backup_date
    return start, finish
  end

  def self.parse(raw, backup = "")
    range(raw, backup)[0]
  end

  def self.try_all_formats raw
    parser = DateWrapper.new raw

    formats.each do |format|
      begin
        result = parser.send format
        return result unless result.nil?
      rescue NoMethodError
      end
    end

    [nil, nil]
  end

  def self.formats
    [
      :month_format,
      :year_slash_year,
      :summer_year,
      :month_and_year_only,
      :just_a_year,
      :format_range_same_year,
      :format_month_range_same_year,
      :raw_range,
      :timestamp
    ]
  end

  def self.date(value)
    begin
      Date.parse(value)
    rescue
      nil
    end
  end
end

class DateWrapper
  def initialize raw
    @raw = raw
  end

  def date value
    MagicDateParser.date(value)
  end

  def timestamp
    if (@raw.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})/))
      day = date(@raw)
      [day, day]
    end
  end

  def month_format
    if @raw.match(/([A-Za-z]+)\s*-\s*(\w+).*(\d{4})\s*$/)
      [date("#{$1} #{$3}"), end_of_month(date("#{$2} #{$3}"))]
    end
  end

  def month_and_year_only
    if @raw.match(/^(\S+)\s*(\d{4})$/)
      start_of_month = date(@raw)
      [start_of_month, end_of_month(start_of_month)]
    end
  end

  def summer_year
    if @raw.match(/Summer\D*(\d{4})/)
      [date("June 21, #{$1}"), date("September 21, #{$1}")]
    end
  end

  def just_a_year
    if @raw.match(/^\D*(\d{4})\s?$/)
      start = Date.civil($1.to_i)
      [start, end_of_year(start)]
    end
  end

  def year_slash_year
    if @raw.match(/(\d{4})\/(\D*)(\d{4})/)
      start = Date.civil($1.to_i)
      finish = end_of_month(date("#{$2} #{$3}"))
      [start, finish]
    end
  end

  def format_month_range_same_year
    if @raw.match(/(\S+)\s+(\d+)\s*-\s*(\d+), (\d{4})/)
      [date("#{$1} #{$2}, #{$4}"), date("#{$1} #{$3}, #{$4}")]
    end
  end

  def format_range_same_year
    if @raw.match(/(\w+)\s+(\d+)\s?-\s?(\S+)\s+(\d+), (\d{4})/)
      [date("#{$1} #{$2}, #{$5}"), date("#{$3} #{$4}, #{$5}")]
    end
  end

  def raw_range
    if @raw.match(/-/)
      @raw.split('-').map { |value| date(value) }
    end
  end

  private
  def end_of_month(date)
    @month_days ||= [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if date.month == 2
      day = Date.gregorian_leap?(date.year) ? 29 : 28
    else
      day = @month_days[date.month - 1]
    end

    Date.new(date.year, date.month, day)
  end

  def end_of_year(date)
    Date.new(date.year, 12, 31)
  end
end
