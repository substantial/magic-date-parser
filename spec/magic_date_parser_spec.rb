require 'spec_helper'

describe MagicDateParser do
  examples = [
    ["May 16, 2004 - April 18, 2005", ["2004-05-16", "2005-04-18"]],
    ["December 29, 1959-January 16, 1960", ["1959-12-29", "1960-01-16"]],
    ["February 13-March 6, 1960", ["1960-02-13", "1960-03-06"]],
    ["December 2-20, 1958", ["1958-12-2","1958-12-20"]],
    ["December 4 - 7, 2008", ["2008-12-4", "2008-12-07"]],
    ["February 7 - March 7, 1992", ["1992-02-07", "1992-03-07"]],

    ["October 22, 2009 - January 16, 2010", ["2009-10-22", "2010-01-16"]],
    ["May 14 - June 15, 2008", ["2008-05-14", "2008-06-15"]],
    ["June 2007", ["2007-06-01", "2007-06-30"]],
    ["2006", ["2006-01-01", "2006-12-31"]],
    ["July 1- August 21, 2010", ["2010-07-01","2010-08-21"]],
    ["August - November 2008", ["2008-08-01", "2008-11-30"]],

    ["September 2 - October 3, 2010 TBC", ["2010-09-02", "2010-10-03"]],
    ["November 3 - December 2, 2000 (extended through March 2, 2001)",
      ["2000-11-03", "2000-12-2"]],
    ["Dates TBC 2009", ["2009-01-01", "2009-12-31"]],
    ["2008/January 2009",["2008-01-01", "2009-1-31"]],
    ["2008/March 2009",["2008-01-01", "2009-3-31"]],
    ["Summer 2001", ["2001-06-21", "2001-09-21"]]
  ]

  examples.each do |example|
    raw = example[0]
    expected_start = Date.parse(example[1][0])
    expected_finish = Date.parse(example[1][1])
    it "parses '#{raw}' as #{expected_start} -> #{expected_finish}" do
      start, finish = MagicDateParser.range(raw)
      start.should == expected_start
      finish.should == expected_finish
    end
  end

  it "should fall back to the second date string if the first fails" do
    start, finish = MagicDateParser.range("", "2009-01-22T00:00:00")
    start.should == Date.parse("2009-01-22")
    finish.should == Date.parse("2009-01-22")
  end

  it "should not support 'movember'" do
    start, finish = MagicDateParser.range("April 6-Movember 26, 2007","2007-04-06T00:00:00")
    start.should == Date.parse("2007-04-06")
    finish.should == start
  end

  describe ".parse" do
    it "should return the first results of .range" do
      MagicDateParser.stub(:range){[13,17]}
      MagicDateParser.parse("foo").should == 13
    end
  end
end

