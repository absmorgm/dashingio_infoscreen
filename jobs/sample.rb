current_valuation = 0
current_karma = 100

SCHEDULER.every '300' do
  last_valuation 	= current_valuation
  last_karma     	= current_karma
  current_valuation = last_valuation + 1
  current_karma     = last_karma - 1

  send_event('valuation', { current: current_valuation, last: last_valuation })
  send_event('karma', { current: current_karma, last: last_karma })
  send_event('synergy',   { value: current_karma })
end