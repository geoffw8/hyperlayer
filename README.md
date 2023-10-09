
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

* [What is Hyperlayer? (00:08)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=00m08s)
* [Why Hyperlayer? (04:40)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=04m40s)
* [Meet the demo app (05:31)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=05m31s)
* [Debugging with Hyperlayer - Viewing spec runs (09:34)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=09m34s)
* [Debugging with Hyperlayer - Application flow & state (10:39)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=10m39s)
* [Debugging with Hyperlayer - Code view (17:56)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=17m56s)
* [We’ve fixed our bug (25:37)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=25m37s)
* [Closing notes (27:47)](https://www.youtube.com/watch?v=9iZkE8ZrFMU&t=27m47s)

## Getting setup

### Installation

Add the gem to your Gemfile

```
gem 'hyperlayer'
```

A few tables are added to handle Hyperlayer objects so `bundle exec rake db:migrate`

Add in your `spec_helper.rb` please add:

```
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

```
mount Hyperlayer::Engine => '/hyperlayer'
```

Note: You must have Redis installed and running locally.

### Using the app

Once you have completed the above, running a spec will cause the emits to be emitted to Redis.

In order to listen to/process the events you must run:
```
rake hyperlayer:listen
```
You should see events coming in as they are processed.

Now simply load `http://localhost:3000/hyperlayer`.

For better instructions I recommend you watch the video - choose one of the "Debugging with Hyperlayer" chapters above!
## Author

I'm [Geoff Wright](https://www.github.com/geoffw8) - Co-Founder & Chief Technology Officer at [Tembo Money](https://tembomoney.com) - the only place in the UK you can view your true house buying budget.

This is a PoC - so I'm super keen for any feedback. Please feel free to reach out!
