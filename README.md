# Steady

This gem is aimed at helping speed up ruby webapps by putting reoccuring but non time critical tasks into a background thread.
It aids with the periodic scheduling as well as the threading issues that arise from moving data between threads. 

# Example

    Scheduler = Steady::Scheduler.new
    
    Scheduler.every 3.seconds do |changes|
      changes[:plans] = JSON.parse(open("http://mysite.com/plans.json")) 
    end 

    # Run all above tasks now to get initial data
    Scheduler.run 

    # Schedule a thread to do this periodically
    Scheduler.schedule


    # Access your data in a thread safe manner 
    Scheduler.data[:plans] 

# Uses at Shopify

* Monitoring read slave lagginess 
* Fetching blog posts to show in the admin
* Fetching centrally configured beta flags from remote 
* and many many more 

