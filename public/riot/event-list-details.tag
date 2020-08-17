<event-list-details>
    <div each="{event, index in opts.events}" > 
      <div class="box shadow1 {event.active ? 'active' : ''} {event.status == 'done' ? 'done' : ''} {  event.status != 'done' && event.time_took_minute > 0  && !event.active ? 'some'  : ''}     " if={show(event)}>
        <div class='title title-header'  >
          <div class='number {event.color}' onclick={toggleDone}>
            {event.task_number}
          </div>
          <div style="display: flex; justify-content: space-between; width: 100%">
            <span class='title'>{event.title}</span>
            <div>
              <span class="time-counter" if="{event.active}">
                {timer(event, this.counterToToggle)}
              </span>
              <span class="button" onclick="{edit}">Edit</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>
    let self = this;
    this.show = function(e) {
      return (self.opts.active && e.active || !self.opts.active && !e.active) 
    } 

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
  </script>
</event-list-details>