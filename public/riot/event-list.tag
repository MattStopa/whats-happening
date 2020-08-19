<event-list>
  <div class="event-list">

    <div>
      <h2 class="my-4 mx-5 text-2xl font-bold">In progress </h2>
      <event-list-details events={events} active={true} edit={edit}></event-list-details>
    </div>

    <div class="spacer">
    </div>

    <div>
      <h2 class="my-4 mx-5 text-2xl font-bold">Tasks</h2>
      <event-list-details events={events} active={false} edit={edit}></event-list-details>
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
      data.minutesTaken = (event.timeTookHour * 60) + event.timeTookMinute 
      data.minutesEst =  (event.estimateHour * 60) + event.estimateMinute 
      data.percentageUsed =  ((event.timeTookHour * 60) + event.timeTookMinute) / ((event.estimateHour * 60) + event.estimateMinute)
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


    rerender() { 
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