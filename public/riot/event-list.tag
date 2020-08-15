<event-list>
  <style>
    .title {
      font-weight: 800;
      cursor: pointer;
      display: flex;
      justify-content: space-between;
    }

    .title.title-header {
      padding: 10px 20px;
      border-bottom: 1px solid #eaecef;
      margin-top: 0px;
    }

    .box.done {
      border: 3px solid #3db741;
      background: #e4fbe5;
    }

    .box.some {
      border: 3px solid #8d8dff;
      background: #e4e4fb;
      color: #5a5720;
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
      margin-left: -48px;
      margin-top: -9px;
      border-radius: 24px;
      background: #b73233;
      border: 1px solid #e0e0e0;
      color: #fff;
      padding-left: 13px;
      padding-top: 9px;
      padding-right: 11px;
    }

    .number.first { background: #83cc00; }
    .number.second { background: #f99114; }
    .number.third { background: #aa7cca; }
    .number.fourth { background: #fef00e; color: #000 !important; }
    .number.fifth { background: #83cc00; }
    .number.sixth { background: #14b5f9; }
    .number.seventh { background: #837a78; }
    .number.eighth { background: #83cc00; }
    .number.nineth { background: #000; color: #000 !important;}
    .number.tenth { background: #fef00e;  color: #000}


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
      background: #83cc00;
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

    h2 {
      margin-left: 21px;
    }

  </style>

  <div class='progress-bar'>
    <div class="progress-display"></div>
  </div>

  <div>
    <h2>In progress </h2>
    <div each="{event, index in events}" class="box shadow1 active" if="{event.active == true}"> 
      <div class='title title-header' >
        <div class='number {event.color}' onclick={toggleDone}>
          {event.task_number}
        </div>
        <div style="display: flex; justify-content: space-between; width: 100%">
          <span class='title'>{event.title}</span>
          <div>
            <span class="button" if="{event.status ==='done'}">
              {minutesData(event).minutesTaken}/{minutesData(event).minutesEst}m {minutesData(event).percentageUsed}%
            </span>
            <span class="time-counter" if="{event.active}">
              {timer(event, this.counterToToggle)}
            </span>
            <span class="button" onclick="{edit}">Edit</span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div style='margin-top: 10px; margin-bottom: 10px; '>
  </div>

  <div>
    <h2>Tasks</h2>
    <div each="{event, index in events}" class="box shadow1 {event.status == 'done' ? 'done' : ''} {event.status != 'done' && event.time_took_minute > 0 ? 'some'  : ''}" if="{event.active != true}"> 
      <div class='title title-header' >
        <div class='number {event.color}' onclick={toggleDone}>
          {event.task_number}
        </div>
        <div style="display: flex; justify-content: space-between; width: 100%">
          <span class='title'>{event.title}</span>
          <div>
            <!--  <span class="button" if="{event.status ==='done'}">
              {minutesData(event).minutesTaken}/{minutesData(event).minutesEst}m {minutesData(event).percentageUsed}%
            </span>  -->
            <span class="button" onclick="{edit}">Edit</span>
          </div>
        </div>
      </div>
      <!--  <div class="box-contents">
        <div class="tags">
          <a class="tag pointer" each={tag in event.tags} href="#topic/{tag.value}">
            {tag.value}
          </a>
          <i class="far fa-edit right" onclick={edit}></i>
        </div>
        <quill-editor contents={event.json_description}></quill-editor>
      </div>  -->
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

    timer(event) {
      let seconds = (Date.now() - parseInt(event.clock_start) ) / 1000
      let minutes = parseInt(seconds / 60)
      let realSeconds = parseInt(seconds % 60)

      let hours = minutes / 60

      // for display: add a zero in front if from 0 to 9
      if(realSeconds < 10) {
        realSeconds = "0" + realSeconds
      }

      if(hours > 1) { 

        return `${parseInt(hours)}:${minutes % 60}:${realSeconds}`
      } else {
        return `${minutes}:${realSeconds}`
      }
    }

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

    xObserve.listen('tagChanged', function(tag){ 
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

    xObserve.listen('editorClosed', function(event) { 
      let data = JSON.parse(localStorage.getItem("filterAndSort"))
      new EventService().forBucketSorted(self.bucket._id.$oid, data, function(json) { 
        self.events = json
        self.rerender()
      }) 
    })

    xObserve.listen('sort', function(data) { 
       new EventService().forBucketSorted(self.bucket._id.$oid, data, function(json) { 
          xObserve.trigger('bucketResults', json)
          self.events = json
          self.rerender()
        })
    })

  </script>
</event-list>