namespace :hyperlayer do
  desc "Run the hyperlayer listen method"
  
  task listen: :environment do
    # Call the method you want to run here
    ImportEvents.call
  end
end
