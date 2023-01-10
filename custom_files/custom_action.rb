#This class is where all customer deciders go
class CustomAction
  include DecidersHelper

  attr_accessor :waiting_rail

  def determine_next_rail(current_rail)
    self.waiting_rail = current_rail
    deciders = {

    }
    decider = deciders[current_rail.destination_decider_id.to_s]
    return decider.call
  end

  private

  def self.priorities(rails)
    rails.sort_by { |x| x.outgoing_priority }
    return rails
  end




end
