class Util
  def self.time_difference
    9.hours
  end

  def self.us_year
    Time.now.utc.year
  end

  def self.ogame_camelize(term, uppercase_first_letter = true)
    string = term.to_s
    string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { " #{$1}#{$2.capitalize}" }.gsub('/', '::')
  end
end