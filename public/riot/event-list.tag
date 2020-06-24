<event-list>
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

  </style>

  <div class='progress-bar'>
    <div class="progress-display"></div>
  </div>

  {this.opts.bucket}

  <div>
    <h2>In progress </h2>
    <div each="{event, index in events}" class="box shadow1 active" if="{event.active == true}"> 
      <div class='title title-header' >
        <div class='number' onclick={toggleDone}>
         {index + 1}
         <i class='fas fa-tasks' style="margin-left: 5px;position: absolute;margin-top: 3px;"></i>
        </div>
        <div style="display: flex; justify-content: space-between; width: 100%">
          <span class='title'>{event.title}</span>
          <div>
            <span class="button" if="{event.status ==='done'}">
              {minutesData(event).minutesTaken}/{minutesData(event).minutesEst}m {minutesData(event).percentageUsed}%
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
    <div each="{event, index in events}" class="box shadow1 {event.status == 'done' ? 'done' : ''}" if="{event.active != true}"> 
      <div class='title title-header' >
        <div class='number' onclick={toggleDone}>
         {index + 1}
         <i class='fas fa-tasks' style="margin-left: 5px;position: absolute;margin-top: 3px;"></i>
        </div>
        <div style="display: flex; justify-content: space-between; width: 100%">
          <span class='title'>{event.title}</span>
          <div>
            <span class="button" if="{event.status ==='done'}">
              {minutesData(event).minutesTaken}/{minutesData(event).minutesEst}m {minutesData(event).percentageUsed}%
            </span>
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
    this.bucket = ''
    let self = this;

    this.on('update', function() {
      if(this.bucket != this.opts.bucket) {
        this.events = [{title: "Dog"}, {title: 'cat'}, {title: 'rat'}] 
        this.bucket = this.opts.bucket
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
      new EventService().index(function(json) { 
        self.events = json
        self.rerender()
      }) 
    })

    this.on('mount', function() { 
      let tag = this.opts.tag || ''

      if(tag){
        new EventService().byTag(tag, function(json) { 
          self.events = json
          self.rerender()
        }) 
      } else {
        new EventService().index(function(json) { 
          self.events = json
          self.rerender()
        }) 
      }
    })

    
  </script>
</event-list>