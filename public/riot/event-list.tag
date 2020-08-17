<event-list>
  <div class="event-list">
    <div class='progress-bar'>
      <div class="progress-display"></div>
    </div>

    <div>
      <h2>In progress </h2>
      <event-list-details events={events} active={true}></event-list-details>
    </div>

    <div style='margin-top: 10px; margin-bottom: 10px; '>
    </div>

    <div >
      <h2>Tasks</h2>
      <event-list-details events={events} active={false}></event-list-details>
    </div>
  </div>
  <script>

    this.events = null;
    this.bucket = null;
    let self = this;


    // this counter below is only so that you can force the timer to update every 1 second
    // without rerendering the whole page.
    setInterval( function() { 
      self.update()
    }, 1000)


    this.on('update', function() {
      if(!this.bucket || (this.opts.bucket && this.bucket.name != this.opts.bucket.name)) {
        this.bucket = this.opts.bucket
        let data = JSON.parse(localStorage.getItem("filterAndSort"))
        new EventService().forBucketSorted(this.bucket._id.$oid, data, function(json) { 
          xObserve.trigger('bucketResults', json)
          self.events = json
          self.rerender()
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

    toggleDone(e) { 
      e.item.event['status'] = e.item.event['status'] == 'done' ? null : 'done'
      this.rerender();
    }

    navToEvent(e) { 
      e.item.event['displayIndex'] = this.events.indexOf(e.item.event)
      xObserve.trigger('changeMapLocation', e.item.event)
    }

    edit(e) {
      xObserve.trigger('editSelected', e.item.event)
    }

    xObserve.listen('tagChanged', 'event-list', function(tag){ 
      new EventService().byTag(tag, function(json) { 
        self.events = json
        self.rerender()
      }) 
    })

    calcProgressBarSize() {
      let count = 0;
      this.events.forEach( function(event) { 
        if(event.status == 'done') {
          count += 1;
        }
      })
     let percent =  (count / this.events.length ) * 100
     document.getElementsByClassName("progress-display")[0].style.width = percent+ "%"
    }

    rerender() { 
      this.calcProgressBarSize()
      this.update()
    }

    xObserve.listen('editorClosed', 'event-list', function(event) { 
      let data = JSON.parse(localStorage.getItem("filterAndSort"))
      new EventService().forBucketSorted(self.bucket._id.$oid, data, function(json) { 
        self.events = json
        self.rerender()
      }) 
    })

    xObserve.listen('sort', 'event-list', function(data) { 
       new EventService().forBucketSorted(self.bucket._id.$oid, data, function(json) { 
          xObserve.trigger('bucketResults', json)
          self.events = json
          self.rerender()
        })
    })

     this.on('unmount', function() {
      // when the tag is removed from the page
      console.log("UNmounted")
      })

  </script>
</event-list>