<event-form>
  <style>
    .title {
        font-weight: 800;
    }

    .label {
      min-width: 100px;
      display: inline-block;
    }

    .form-holder {
      width: 570px;
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

    .ql-snow {
        margin-bottom: 0px !important;
    }

    .tag-holder {
      width: 401px;
      margin-left: 104px;
      border-radius: 5px;
      margin-top: -33px;
      font-size: 12px;
      margin-bottom: 45px;
    }

    .tagify tag x {
      margin-top: -5px;
    }

    .green-btn {
      color: #03af21;
      border-color: #03af21;
    }
  </style>
  
  <div class="box shadow1">
    <h2 class="header">Event Details <i class="fas fa-times right pointer" onclick={closeEditor}></i></h2>
    <form onsubmit={submitMe} class="form-holder ">
        <div>
          <div class="label">Status</div>
          <div class="button {this.event.status == ''}  {this.event.status=='done' ? 'green-btn' : ''} " onclick={ toggleDone }  >          
            <i class="fas fa-check"  if="{ eventDone(this.event)}"  style='margin-right: 10px'></i> 

            { this.event.status == 'done' ? 'Done' : 'Not Done' } 
          </div>
        </div>
        <div>
          <div class="label">Time Taken</div>
          <div class="button {this.event.active == true ? 'green-btn' : ''} " onclick={ toggleActive }  >          
            <i class="fas fa-check" if={this.event.active == true } style='margin-right: 10px'></i> 

            { this.event.active == true ? 'Stop' : 'Start' } 
          </div>
        </div>        
        <div>
          <div class="label">Title</div>
          <input type="text" name="title" onblur={ doneEdit } value={event.title}  autocomplete="off" >
        </div>
        <!--  <div>
          <div class="label">Tags</div>
          <div class="tag-holder tag-input"></div>
        </div>  -->
        <div>
          <div class="label">Date Finished</div>
          <input type="text" id="datepicker" name="date_finished" onblur={ doneEdit } value={event.date_finished}  autocomplete="off" >
        </div>
        <div style="border-bottom: 2px solid #d8d8d8"></div>
        <div>
          <div class="label">Hour Est.</div>
          <input type="text" name="estimate_hour" onblur={ doneEdit } value={event.estimate_hour}  autocomplete="off" >

          <div class="label">Minute Est.</div>
          <input type="text" name="estimate_minute" onblur={ doneEdit } value={event.estimate_minute}  autocomplete="off" >
        </div>
        <div style="border-bottom: 2px solid #d8d8d8"></div>
        <div>
          <div class="label">Hours taken</div>
          <input type="text" name="time_took_hour" onblur={ doneEdit } value={event.time_took_hour}  autocomplete="off" >

          <div class="label">Min. Taken</div>
          <input type="text" name="time_took_minute" onblur={ doneEdit } value={event.time_took_minute}  autocomplete="off" >
        </div>
        <div style="border-bottom: 2px solid #d8d8d8"></div>  
        <div>
          <div class="label" style='vertical-align: top'>Info</div>
          <div class="editor"></div>
        </div>
        <div style="display: flex; justify-content: space-between">
          <button class="button" type="submit">
            { event._id ? 'Save' : 'Create' } 
          </button>
          <div class="button" type="submit" onclick={deleteTask}>
            Delete Task
          </div>
        </div>
    </form>
  </div>
 
  <script>
    this.events = null;
    let self = this;

    this.dirty = false;
    this.event = {};
    this.picker = null
    this.quill = null;
    this.tagify = null;

    // For some reason when this is triggered you have to wait some MS for riot to be ready. 
    // I have no idea what is causing this.
    xObserve.listen('editSelected', function(event) { 
      self.dirty = false;
      self.event = event;

  
      // Set picker date time if it exists already
      if(self.event.date_finished) {
        window.picker = self.picker

        // This timeout below MUST occur AFTER the update() timeout listed below. Otherwise the update
        // occurs and the timer can't set the object. It's strange, idk why, but it's important. 
        setTimeout(function() { 
          self.picker.setDate(self.event.date_finished)
        }, 20)

      }

      // Set quill contents
      setTimeout(function() { 
          self.quill.setContents(self.event.json_description)

      }, 10)
      setTimeout(function() { 
        self.update()
      }, 10)
    })

    xObserve.listen('createNewEvent', function(event) { 
      self.event = {};
      self.update()
    })

    eventDone(event) { 
      let val = event && event.status && event.status == 'done'
      return val || false
    }

    toggleDone(e) { 
      this.setDirty()
      this.event.status = this.event.status == 'done' ? 'not done' : 'done'
      if(this.event.active) {
        this.toggleActive()
      }
      self.picker.setDate(new Date())
    }

    setDirty() { 
      this.dirty = true
    }

    doneEdit(e) {
      if(this.hasActuallyChanged(this.event[e.target.name], e.target.value))  {
        this.event[e.target.name] = e.target.value;
        this.setDirty()
      }
    }

    //Turns a task on or off, meaning you are currently working on it or not.
    toggleActive()  {
      this.event.active = !this.event.active;
      if(this.event.active) {
        this.event.clock_start = Date.now()
      } else {
        let milli = Date.now() - this.event.clock_start
        let mins = parseInt(milli / 60000) || 1
        this.event.time_took_minute = parseInt(this.event.time_took_minute || '0') + mins 
      }
      this.submitMe()
    }

    // Basically prevent empty strings from looking like nulls, lets just ignore those. Also lets convert all numbers into strings, 
    // so we just do string compares so there are not any type issues.
    hasActuallyChanged(str1, str2) { 
      return (!(str1 === null && str2 === '') || (str1 === '' && str2 === null)) && (str1 +"" != str2 +"")
    }

    tagEntered(e) { 
      if(e.code == 'Enter') {
        this.event.tags = e.target.value.split(" ")
      }
    }

    deleteTask(e) { 
      let msg = "Are you sure you want to delete this task? If you do it will be put in your deleted bucket. You can then restore it if needed in the next 30 days"
      if(confirm(msg)) {
        fetch('/events/' + self.event._id['$oid'], {
          method: 'delete',
          headers: {
            'Content-Type': 'application/json'
          }
        }).then(function() { 
          new Noty({
              timeout: 3000,
              type: 'success',
              text: 'Successfully Deleted',
          }).show();
            
          self.dirty = false;  
          self.closeEditor()
        }).catch(function() {
            new Noty({
              timeout: 3000,
              type: 'error',
              text: 'There was an issue saving',
          }).show();
        })
      }
    }

    input(e) {
      this.event[e.target.name] = e.target.value;
    }

    function addMarker(latlng,title,map) {
        var marker = new google.maps.Marker({
                position: latlng,
                map: map,
                title: title,
                draggable:true
        });
    }

    this.on('mount', function() {
      self.picker = new Pikaday({ field: document.getElementById('datepicker') });

      var input = document.querySelector('.tag-input')
      self.tagify = new Tagify(input, {whitelist:[]})

      var options = {
        modules: {
          toolbar: {
            container: [
              ['bold', 'italic', 'underline'], 
              ['blockquote', 'code-block'], 
              [{ 'indent': '-1'}, { 'indent': '+1' }], 
              ['link', 'image'],
              [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
              [{ 'font': [] }], 
              [{ 'align': [] }],
              [ 'clean' ] 
            ],
            handlers: {
              'link': function(value) {
                if (value) {
                  var href = prompt('Enter the URL');
                  this.quill.format('link', href);
                } else {
                  this.quill.format('link', false);
                }
              },
              'image': function imageHandler() {
                var range = this.quill.getSelection();
                var value = prompt('What is the image URL');
                this.quill.insertEmbed(range.index, 'image', value, Quill.sources.USER);
              }
            }
          }
        },
        placeholder: 'Compose an epic...',
        theme: 'snow'
      };

      this.quill = new Quill('.editor', options); 

      this.quill.on('text-change', function(delta, oldDelta, source) {
        self.event.json_description = self.quill.getContents();
        self.event.description = self.quill.getText();
      });

    })

    
    submitMe(e) {
      if(e) { 
        e.preventDefault()
      }

      let method = 'POST';
      let url = 'events'

      self.event.bucket = self.opts.bucket

      if(self.event._id) {
        url = '/events/' + self.event._id['$oid']
        method = 'PUT'
      }

      fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ event: self.event })
      }).then(function() { 
        new Noty({
            timeout: 3000,
            type: 'success',
            text: 'Successfully Saved',
        }).show();
        
        self.dirty = false;  
        if(e) {
          self.closeEditor()
        }


      }).catch(function() {
          new Noty({
            timeout: 3000,
            type: 'error',
            text: 'There was an issue saving',
        }).show();
      } )

    }

    closeEditor() {
      if(this.dirty) {
        let val = confirm("Are you sure you want to leave? You haven't saved.")
        if(!val) { 
          return
        }
      }
      this.event = {}
      xObserve.trigger('editorClosed')
    }

  </script>
</event-form>