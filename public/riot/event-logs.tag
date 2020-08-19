<event-logs>
  <div class="logs">
    <h2>Logs</h2>
    <div each="{key in Object.keys(groupBy)}" class="box">
      <div class='log-entry'>
        <h2>{key}</h2> <div class="time-taken"><i class="fas fa-clock clock"></i>{timer(totalTimeTaken(groupBy[key]))}</div> 
      </div> 
      <div each="{event in groupBy[key]}" class="entry">
        <div class='title'>{event.title}</div>
        <div class='time-taken-mini'>  +{timer(event.timeTookHour * 60 + event.timeTookMinute)}</div>
      </div>
    </div>
  </div>

  <script>

    this.events = null;
    this.bucket = null;
    let self = this;
    this.groupBy = {};

    timer(min) {
      console.log(min)
      let minutes = min
      let hours = minutes / 60


      let displayMinutes = minutes % 60;
      if(displayMinutes < 10){ 
        displayMinutes = "0" + displayMinutes
      }

      if(hours > 1) { 
        return `${parseInt(hours)}:${displayMinutes}`
      } else {
        return `${minutes}`
      }
    }

    totalTimeTaken(items) {
      let minutes = 0;
      items.forEach(function(event){ 
        minutes = minutes + event.timeTookMinute + (event.timeTookHour * 60)
      })
      return minutes
    }

    this.on('update', function() {
      if(!this.bucket || (this.opts.bucket && this.bucket.name != this.opts.bucket.name)) {
        this.bucket = this.opts.bucket
        new EventService().forBucketByDate(this.bucket._id.$oid, function(json) { 
          xObserve.trigger('bucketResults', json)

          let groupBy = {}
          groupBy['Totals'] = []
          json.forEach(function(item) { 
            if(item.date_finished) {
              let key = item.date_finished.split("T")[0]
              groupBy[key] = groupBy[key] || []
              groupBy[key].push(item)
              groupBy['Totals'].push(item)
            }
          })

          self.groupBy = groupBy

          self.events = json
          self.update()
        })
      }
    })


    minutesData(event) { 
      data = {}
      data.minutesTaken = (event.timeTookHour * 60) + event.timeTookMinute 
      data.minutesEst =  (event.estimateHour * 60) + event.estimateMinute 
      data.percentageUsed =  ((event.timeTookHour * 60) + event.timeTookMinute) / ((event.estimateHour * 60) + event.estimateMinute)
      data.percentageUsed = 100 - parseInt((100 * data.percentageUsed) )
      return data
    }

    navToEvent(e) { 
      e.item.event['displayIndex'] = this.events.indexOf(e.item.event)
      xObserve.trigger('changeMapLocation', e.item.event)
    }

  </script>
</event-logs>