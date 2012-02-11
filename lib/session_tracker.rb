require 'time'

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

  def active_users(time = Time.now)
    @redis.sunion(*keys_for_last_3_minutes(time)).size
  end

  private
  
  def keys_for_last_3_minutes(time)
    times = 0.upto(2).map { |n| time - (n * 60) }
    times.map { |t| key_for(t) }
  end

  def key_for(time)
    "active_#{@type}_sessions_minute_#{time.strftime("%M")}"
  end
end
