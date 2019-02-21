<event-form>
  <style>
    .title {
        font-weight: 800;
    }

    .label {
      min-width: 100px;
      display: inline-block;
      vertical-align: top;
    }

    .form-holder {
      width: 400px;
      padding: 21px;
    }

    .form-holder div {
      margin-bottom: 10px;
    }

    input, textarea {
      line-height: 20px;
      transition: background .1s ease,border-color .1s ease;
      -webkit-appearance: none;
      -moz-appearance: none;
      outline: 0;
      border-radius: 4px;
      font-size: 13px;
      border: 1px solid #cfd7e6;
      box-shadow: inset 0 1px 2px 0 rgba(207,215,230,.4);
      box-shadow: 0 1px 3px 0 rgba(89,105,129,.05), 0 1px 1px 0 rgba(0,0,0,.025);
      padding: 0 30px 0 10px;
      height: 32px;
      background-color: #fff;
      background-repeat: no-repeat;
      background-position: 100%;
      width: 63%;
    }



  </style>
  
  <div class="box shadow1">
    <h2 class="header">Event Details <i class="fas fa-times right pointer"></i></h2>
    <form onsubmit={submitMe} class="form-holder ">
        <div>
          <div class="label">Title</div>
          <input type="text" name="title" onblur={ doneEdit } value={event.name}>
          {event.name}
        </div>
        <div>
          <div class="label">Description</div>
          <textarea type="text" name="description" onblur={ doneEdit }  style="height: 70px"></textarea>
        </div>
        <div>
          <div class="label">Coord X</div>
          <input type="text" name="coord_x" onblur={ doneEdit }  >
        <div>
        </div>
          <div class="label">Coord Y</div>
          <input type="text" name="coord_y" onblur={ doneEdit }  >
        </div>
        <button class="button" type="submit">Create</button>
    </form>
  </div>
 
  <script>
    this.events = null;
    let self = this;

    this.event = {};

    xObserve.listen('editSelected', function(event) { 
      self.event = event;
      console.log(self.event)
      console.log(self)
      self.update()
    })

    doneEdit(e) {
      this.opts[e.target.name] = e.target.value;
    };

    input(e) {
      this.opts[e.target.name] = e.target.value;
    }
    
    submitMe(e) {
      e.preventDefault()

      fetch('/events', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ event: self.opts })
      })
    }

  </script>
</event-form>