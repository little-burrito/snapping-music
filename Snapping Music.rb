#
# Snapping Music for one computer
#  by Anton Lejon (2020)
#
# A Sonic Pi implementation of
#
# Clapping music for two performers
#  by Steve Reich (1972)
#
# Dedicated to Kim Helweg
#

use_bpm Random.rand(160..184)

# Score
$base_phrase = [1,1,1,0,1,1,0,1,0,1,1,0]
$total_measures = $base_phrase.count() + 1
$repetitions_per_measure = 12

# Interpretation
$humanization = 0.03                  # Maximum delay of each clap - max is 0.5 (greater than that will desync the two clappers)
$normal_amplitude_range = 0.65..0.8   # Volume of normal claps
$accented_amplitude_range = 0.95..1   # Volume of accented claps
$sample_rate_range = 0.97..1.03       # Playback rate of the clap sample



def PlayMeasure(offset, clap_sample)
  beats_in_phrase = $base_phrase.count()
  
  for i in 0..$repetitions_per_measure - 1
    # sample :drum_heavy_kick # debug kick :D
    
    for beat_number in 0..beats_in_phrase - 1
      current_beat = $base_phrase[(beat_number + offset) % beats_in_phrase]
      accent = beat_number == 0
      PlayBeat(current_beat, accent, clap_sample)
    end
    
  end
  
end



def PlayBeat(beat, accent, clap_sample)
  current_beat_humanization = Random.rand(0..$humanization)
  sleep current_beat_humanization
  
  if beat == 1
    
    amplitude = accent ? Random.rand($accented_amplitude_range) : Random.rand($normal_amplitude_range)
    rate = Random.rand($sample_rate_range)
    
    with_fx :reverb, room: 0.2 do
      sample clap_sample, amp: amplitude, rate: rate
    end
    
  end
  
  sleep 0.5 - current_beat_humanization
  
end



# Clap 1
in_thread do
  for current_measure in 1..$total_measures
    offset = 0
    PlayMeasure(offset, :perc_snap2)
  end
end

# Clap 2
in_thread do
  for current_measure in 1..$total_measures
    offset = current_measure - 1
    PlayMeasure(offset, :perc_snap)
  end
end
