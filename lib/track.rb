require 'appscript'

class Track

  def self.current_track
     "Now Listening: #{Appscript::app('iTunes').current_track.name.get} by #{Appscript::app('iTunes').current_track.artist.get}"
  end
end