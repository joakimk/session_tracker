require "time"

class SessionTracker
  ONE_HOUR = 60 * 60

  def initialize(type, redis = $redis)
    @type = type
    @redis = redis
  end

  def track(id, time = Time.now)
    return unless id
    key = key_for(time)
    @redis.sadd(key, id)
    @redis.expire(key, ONE_HOUR - 60)
  rescue
    # This is called for every request and is probably not essential for the app
    # so we don't want to raise errors just because redis is down for a few seconds.
  end

  def active_users_data(timespan_in_minutes, time)
    @redis.sunion(*keys_within(timespan_in_minutes, time))
  end

  def active_users(timespan_in_minutes = 5, time = Time.now)
    active_users_data(timespan_in_minutes, time).size
  end

  private
  
  def keys_within(minutes, time)
    times = 0.upto(minutes - 1).map { |n| time - (n * 60) }
    times.map { |t| key_for(t) }
  end

  def key_for(time)
    "active_#{@type}_sessions_minute_#{time.strftime("%M")}"
  end
end
