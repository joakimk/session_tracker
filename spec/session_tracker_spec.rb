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

describe SessionTracker, "active_users" do

  let(:redis) { mock.as_null_object }

  it "should do a union on the last 5 minutes to get a active user count" do
    time = Time.parse("13:09")
    redis.should_receive(:sunion).with("active_customer_sessions_minute_09",
                                       "active_customer_sessions_minute_08",
                                       "active_customer_sessions_minute_07").
                                       and_return([ mock, mock ])

    SessionTracker.new("customer", redis).active_users(3, time).should == 2
  end

  it "should use a default time span of 5 minutes" do
    redis.should_receive(:sunion).with(anything, anything, anything,
                                       anything, anything).and_return([ mock, mock ])

    SessionTracker.new("customer", redis).active_users.should == 2
  end

  it "should be possible to access the data" do
    redis.should_receive(:sunion).and_return([ :d1, :d2 ])
    SessionTracker.new("customer", redis).active_users_data(3, Time.now).should == [ :d1, :d2 ]
  end

end
