require 'session_tracker'

describe SessionTracker, "track" do
  
  let(:redis) { double.as_null_object }

  it "should store the user in a set for the current minute" do
    time = Time.parse("15:04")
    expect(redis).to receive(:sadd).with("active_customer_sessions_minute_04", "abc123")
    tracker = SessionTracker.new("customer", redis)
    tracker.track("abc123", time)
  end

  it "should expire the set within an hour to prevent it wrapping around" do
    time = Time.parse("15:59")
    expect(redis).to receive(:expire).with("active_customer_sessions_minute_59", 60 * 59)
    tracker = SessionTracker.new("customer", redis)
    tracker.track("abc123", time)
  end

  it "should be able to track different types of sessions" do
    time = Time.parse("15:04")
    expect(redis).to receive(:sadd).with("active_employee_sessions_minute_04", "abc456")
    tracker = SessionTracker.new("employee", redis)
    tracker.track("abc456", time)
  end

  it "should do nothing if the session id is nil" do
    expect(redis).not_to receive(:sadd)
    expect(redis).not_to receive(:expire)
    tracker = SessionTracker.new("employee", redis)
    tracker.track(nil)
  end

  it "should not raise any errors" do
    expect(redis).to receive(:expire).and_raise('fail')
    tracker = SessionTracker.new("customer", redis)
    tracker.track("abc123", Time.now)
  end

end

describe SessionTracker, "active_users" do

  let(:redis) { double.as_null_object }

  it "should do a union on the specified timespan to get a active user count" do
    time = Time.parse("13:09")
    expect(redis).to receive(:sunion).with("active_customer_sessions_minute_09",
                                       "active_customer_sessions_minute_08",
                                       "active_customer_sessions_minute_07").
                                       and_return([ double, double ])

    expect(SessionTracker.new("customer", redis).active_users(3, time)).to eq(2)
  end

  it "should use a default time span of 5 minutes" do
    expect(redis).to receive(:sunion).with(anything, anything, anything,
                                       anything, anything).and_return([ double, double ])

    expect(SessionTracker.new("customer", redis).active_users).to eq(2)
  end

  it "should be possible to access the data" do
    expect(redis).to receive(:sunion).and_return([ :d1, :d2 ])
    expect(SessionTracker.new("customer", redis).active_users_data(3, Time.now)).to eq([ :d1, :d2 ])
  end

end
