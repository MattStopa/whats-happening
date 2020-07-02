<event-logs>
  <style>
    .title {
      font-weight: 800;
      cursor: pointer;
      display: flex;
      justify-content: space-between;
    }

    .title.title-header {

      padding: 20px;
      border-bottom: 1px solid #eaecef;
      margin-top: 0px;
    }

    .box.done {
      border: 3px solid #3db741;
      background: #e4fbe5;
    }

    .box .box-contents {
      padding: 20px;
      margin-bottom: 20px;
      margin-bottom: 4px;
    }

    .fa-edit {
      color: #ff9922;
      cursor: pointer;
    }

    .tags { 
      margin-left: 16px;
    }

    a.tag {
      text-decoration: none;
    }
    .number {
      position: absolute;
      height: 32px;
      width: 27px;
      margin-left: -48px;
      margin-top: -9px;
      border-radius: 24px;
      background: #b73233;
      border: 1px solid #e0e0e0;
      color: #fff;
      padding-left: 13px;
      padding-top: 9px;
      padding-right: 8px;
    }

    .title { 
      margin-left: 10px;
    }

    .progress-bar { 
      height: 20px;
      width: 95%;
      background: #fff;
      margin-left: 19px;
      margin-bottom: 16px;
      padding: 4px 5px;
      border: 2px solid #eaeaea;
      border-radius: 5px;
      text-align: center;
    }

    .progress-display {
      background: #9ebda0;
      width: 50%;
      height: 20px;
    }

    .active {
      background: #ece2cb;
      border: 2px solid #ffb200;
    }

    .time-counter {
      margin-right: 10px;
      background: #b37e00;
      color: #fff;
      padding: 5px;
      border-radius: 6px;
    }

  </style>

  <div>
    <h2>Logs</h2>
    <div each="{key in Object.keys(groupBy)}" class="box shadow1"> 
      <h2>{key} - {timer(totalTimeTaken(groupBy[key]))}</h2>
      <div each="{event in groupBy[key]}">
        {event.title} - {timer(event.time_took_hour * 60 + event.time_took_minute)}
      </div>
      <!--  <div class='title title-header' >
        <div style="display: flex; justify-content: space-between; width: 100%">
          <span class='title'>{event.title}</span>
          <div>
            <span class="button" if="{event.status ==='done'}">
              {minutesData(event).minutesTaken}/{minutesData(event).minutesEst}m {minutesData(event).percentageUsed}%
            </span>
            <span class="button" onclick="{edit}">Edit</span>
          </div>
        </div>
      </div>  -->

    </div>
  </div>

  <script>

    this.events = null;
    this.bucket = null;
    let self = this;
    this.groupBy = {};

    timer(min) {
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
        minutes = minutes + event.time_took_minute + (event.time_took_hour * 60)
      })
      return minutes
    }

    this.on('update', function() {
      if(!this.bucket || (this.opts.bucket && this.bucket.name != this.opts.bucket.name)) {
        this.bucket = this.opts.bucket
        new EventService().forBucketByDate(this.bucket._id.$oid, function(json) { 
          xObserve.trigger('bucketResults', json)

          let groupBy = {}
          groupBy['unassigned'] = []
          json.forEach(function(item) { 
            if(item.date_finished) {
              let key = item.date_finished.split("T")[0]
              groupBy[key] = groupBy[key] || []
              groupBy[key].push(item)
            } else {
              groupBy['unassigned'].push(item)
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
      data.minutesTaken = (event.time_took_hour * 60) + event.time_took_minute 
      data.minutesEst =  (event.estimate_hour * 60) + event.estimate_minute 
      data.percentageUsed =  ((event.time_took_hour * 60) + event.time_took_minute) / ((event.estimate_hour * 60) + event.estimate_minute)
      data.percentageUsed = 100 - parseInt((100 * data.percentageUsed) )
      return data
    }

    navToEvent(e) { 
      e.item.event['displayIndex'] = this.events.indexOf(e.item.event)
      xObserve.trigger('changeMapLocation', e.item.event)
    }

  </script>
</event-logs>