def probability_by_delta_seat(delta)
  # Upset odds based on historical precedent (with some smoothing applied)
  # Equal seats should return 50-50 probability
  # Maximum spread (15) should return "close to" absolute 100-0 odds
  case delta
  when 15
    1.0
  when 14
    0.96
  when 13
    0.93
  when 12
    0.89
  when 11
    0.85
  when 10
    0.81
  when 9
    0.77
  when 8
    0.72
  when 7
    0.68
  when 6
    0.66
  when 5
    0.64
  when 4
    0.62
  when 3
    0.60
  when 2
    0.57
  when 1
    0.53
  when 0
    0.5
  else
    1 - probability_by_delta_seat(delta * -1)
  end
end

def winner_by_seat?(seat_1, seat_2)
  delta = seat_1 - seat_2
  ([*1..100].sample >= probability_by_delta_seat(delta) * 100) ? seat_1 : seat_2
end

# This is a less useful predictor: low-ranking teams often have high win ratios
def probability_by_win_ratio(delta)
  # A team wins between 0% and 100% of its games
  # Comparing two teams, the difference in percentages will also be between 0% and 100%
  # If they have equal win percentages, then it is a tossup--50/50
  # If one team has won 100% and the other has won 0%,
  # ...then there is a 100% win percentage different between them
  # ...in that case, the odds should be 100% in favor of the 100% team.
  0.5 + 0.5 * delta
end

def winner_by_win_ratio?(ratio_1, ratio_2)
  delta = ratio_1 - ratio_2
  ([*1..100].sample >= probability_by_delta_seat(delta) * 100)
end

def winner_by_half_and_half?(ratios, seat_1, seat_2)
  delta_win_ratio = ratios[seat_2 - 1] - ratios[seat_1 - 1]
  win_ratio_odds = probability_by_win_ratio(delta_win_ratio)
  delta_seat = seat_2 - seat_1
  seat_odds = probability_by_delta_seat(delta_seat)
  overall_odds = (0.5 * seat_odds) + (0.5 * win_ratio_odds)
  ([*1..100].sample >= overall_odds * 100) ? seat_1 : seat_2
end
