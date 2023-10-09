
# ⚡️ Hyperlayer

Debug your Ruby apps 10x faster.

> Depending on which research you look at, developers say they tend to spend 25–50% of their time per year on debugging.

## What is Hyperlayer?

An entirely new way to visualise Ruby apps, combining application flow, state and the code itself.

Removes a lot of what we’re having to do manually to debug apps.

It is a paradigm shift in how we engineer software.

Works out of the box, supporting any Ruby based app.

This is just the beginning.

## Watch the video
[![Introduction to Hyperlayer](http://img.youtube.com/vi/9iZkE8ZrFMU/0.jpg)](http://www.youtube.com/watch?v=9iZkE8ZrFMU "Introduction to Hyperlayer")

* [What is Hyperlayer?](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=00m08s) (00:08)
* [Why Hyperlayer?](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=04m40s) (04:40)
* [Meet the demo app](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=05m31s) (05:31)
* [Debugging with Hyperlayer - Viewing spec runs](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=09m34s) (09:34)
* [Debugging with Hyperlayer - Application flow & state](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=10m39s) (10:39)
* [Debugging with Hyperlayer - Code view](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=17m56s) (17:56)
* [We’ve fixed our bug](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=25m37s) (25:37)
* [Closing notes](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=27m47s) (27:47)

## Getting setup

### Installation

Add the gem to your Gemfile

```ruby
gem 'hyperlayer'
```

Hyperlayer adds a few tables so `bundle exec rake db:migrate`

In your `spec_helper.rb` add:

```ruby
RSpec.configure do |config|
  # Add this block
  config.around(:each) do |example|
    trace = Hyperlayer::Tracer.setup_trace
    trace.enable

    example.run

    trace.disable
  end

  ...
end
```

Finally mount the UI by adding this to your `routes.rb`:

```ruby
mount Hyperlayer::Engine => '/hyperlayer'
```

Note: You must have Redis installed and running locally.

### Using Hyperlayer

Once you have completed the above, running a spec will cause the events to be emitted to Redis.

In order to listen to/process the events you must run:
```ruby
rake hyperlayer:listen
```
You should see events coming in as they are processed.

Now simply load `http://localhost:3000/hyperlayer`.

For better instructions I recommend you watch the video - choose one of the "Debugging with Hyperlayer" chapters above!
## Author

I'm [Geoff Wright](https://www.linkedin.com/in/geoffw8) - Co-Founder & Chief Technology Officer at [Tembo Money](https://tembomoney.com) - the only place in the UK you can view your true house buying budget.

This is a PoC - so I'm super keen for any feedback. Please feel free to reach out!
