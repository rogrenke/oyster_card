require_relative 'fare'
require_relative 'station'
require_relative 'journey'

class Oystercard

  attr_reader :balance, :entry_station, :journeys
  MAX_BALANCE = 90

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    fail "Cannot top_up above #{MAX_BALANCE}" if amount + @balance > MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    return false if @journeys.empty?
    @journeys[-1].entry_station != :no_station && @journeys[-1].exit_station == :no_station
  end

  def touch_in(station)
    fail "Balance below minimum" if @balance < Fare::MIN_FARE
    @journeys << Journey.new.start_journey(station)
  end

  def touch_out(exit_station)
    deduct_fare(Fare::MIN_FARE)
    record_journey(entry_station, exit_station)
  end

  private

  def deduct_fare(fare)
    @balance -= fare
  end

  def record_journey(station1, station2)
    @journeys["journey#{journeys.length+1}".to_sym] = [station1, station2]
  end

end
