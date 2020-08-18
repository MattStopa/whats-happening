<event-list-details>
    <div each="{event, index in opts.events}" > 
      <div class="box shadow1 {event.active ? 'active' : ''} {event.status == 'done' ? 'done' : ''} {  event.status != 'done' && 
      (event.time_took_hour > 0 || event.time_took_minute > 0 ) && !event.active ? 'some'  : ''}     " if={show(event)}>
        <div class='title title-header'  >
          <div class='number {event.color}'>
            {event.task_number}
          </div>
          <div class="list-item">
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

    this.edit = function(e){ 
      self.opts.edit(e)
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
        final_minutes = minutes % 60
        if(final_minutes > 0 && final_minutes < 9 ) {
          final_minutes = "0" + final_minutes;
        }
        return `${parseInt(hours)}:${final_minutes}:${realSeconds}`
      } else {
        return `${minutes}:${realSeconds}`
      }
    }
  </script>
</event-list-details>