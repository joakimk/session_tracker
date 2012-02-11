require 'session_tracker'

describe SessionTracker, "track" do
  
  let(:redis) { mock.as_null_object }

  it "should store the user in a set for the current minute" do
    time = Time.parse("15:04")
    redis.should_receive(:sadd).with("active_customer_sessions_minute_04", "abc123")
    tracker = SessionTracker.new("customer", redis)
    tracker.track("abc123", time)
  end

  it "should expire the set within an hour to prevent it wrapping around" do
    time = Time.parse("15:59")
    redis.should_receive(:expire).with("active_customer_sessions_minute_59", 60 * 59)
    tracker = SessionTracker.new("customer", redis)
    tracker.track("abc123", time)
  end

  it "should be able to track different types of sessions" do
    time = Time.parse("15:04")
    redis.should_receive(:sadd).with("active_employee_sessions_minute_04", "abc456")
    tracker = SessionTracker.new("employee", redis)
    tracker.track("abc456", time)
  end

  it "should do nothing if the session id is nil" do
    redis.should_not_receive(:sadd)
    redis.should_not_receive(:expire)
    tracker = SessionTracker.new("employee", redis)
    tracker.track(nil)
  end

  it "should not raise any errors" do
    redis.should_receive(:expire).and_raise('fail')
    tracker = SessionTracker.new("customer", redis)
    tracker.track("abc123", Time.now)
  end

end
