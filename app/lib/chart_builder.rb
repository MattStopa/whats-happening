class ChartBuilder


  def self.format_chart_data(query)
    chart_data = {}

    # Loop through and every time you find an item for a specific day add it. 
    # This has to accomodate multiple days. 
    query.map { |item| 
        key = "#{item.date_finished.month}/#{item.date_finished.day}"
        chart_data[key] ||= []
        chart_data[key].push(item)
    }

    # Have to loop through again here because we were adding all the elements. Now they are 
    # there and we can get a sum.     
    chart_data.map { |key, value|
        chart_data[key] = value.size
    }

    chart_data
  end

  def self.init_data
    {
        labels: [],
        data: []
    }
  end


  def self.gen_bar_chart(id, days, type)
    query =  Bucket.find(id).events.where(status: :'done', :date_finished.gte => days.days.ago).order_by(date_finished: :desc)

    chart_data = format_chart_data(query)
    data = init_data

    days.times do |num|
        key = "#{num.days.ago.month}/#{num.days.ago.day}"
        data[:labels].push(key)
        data[:data].push(chart_data[key] || 0)
    end

    data[:labels].reverse!
    data[:data].reverse!
    data
  end

  def self.gen_burn_chart(id, days, type)
    query =  Bucket.find(id).events.where(status: :'done', :date_finished.gte => days.days.ago).order_by(date_finished: :desc)

    chart_data = format_chart_data(query)

    data = init_data

    total = Bucket.find(id).events.where(:status.ne => 'done').length + query.length
    days.downto(0) do |num|
        key = "#{num.days.ago.month}/#{num.days.ago.day}"
        data[:labels].push(key)
        total = total - (chart_data[key] || 0)
        data[:data].push(total)
    end

    data
  end


  def self.gen_build_chart(id, days, type)
    query =  Bucket.find(id).events.where(status: :'done', :date_finished.gte => days.days.ago).order_by(date_finished: :desc)

    chart_data = format_chart_data(query)
    data = init_data

    total = 0
    days.downto(0) do |num|
        key = "#{num.days.ago.month}/#{num.days.ago.day}"
        data[:labels].push(key)
        total = total + (chart_data[key] || 0)
        data[:data].push(total)
    end

    data
  end
end