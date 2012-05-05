require 'time'

class SessionTracker
  ONE_HOUR = 60 * 60

  attr_accessor :options, :redis, :type

  def initialize(type, options = {})
    @type = type
    options = { :redis => options } unless options.is_a?(Hash)
    @options = options
    @redis = options[:redis] || (defined?($redis) && $redis) || (defined?(REDIS) && REDIS)
  end

  def track(id, time = Time.now)
    return unless id
    key = key_for(time)
    redis.sadd(key, id)
    redis.expire(key, ONE_HOUR - 60)
  rescue StandardError
    # This is called for every request and is probably not essential for the app
    # so we don't want to raise errors just because redis is down for a few seconds.
    raise if options[:propagate_exceptions]
  end

  def active_users_data(timespan_in_minutes = 5, time = Time.now)
    redis.sunion(*keys_within(timespan_in_minutes, time))
  end

  def active_friends(friend_ids_key, options = {})
    tmp_key = random_key
    redis.sunionstore(tmp_key, *keys_within(options[:timespan_in_minutes] || 5, options[:time] || Time.now))
    redis.sinter(tmp_key, friend_ids_key)
  ensure
    redis.del(tmp_key)
  end

  def active_users(timespan_in_minutes = 5, time = Time.now)
    active_users_data(timespan_in_minutes, time).size
  end

  def random_key
    (Time.now.to_f + rand * 100_000_000).to_s
  end

  private

  def keys_within(minutes, time)
    times = 0.upto(minutes - 1).map { |n| time - (n * 60) }
    times.map { |t| key_for(t) }
  end

  def key_for(time)
    "active_#{type}_sessions_minute_#{time.strftime("%M")}"
  end
end
