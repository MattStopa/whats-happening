<event-form>

  <div class="event-form border-2 border-grey-400 {opts.showEditor ? 'visible' : ''}" > 
  <div class=" bg-gray-100  shadow-lg rounded-sm text-sm text-black">
    <div class="flex font-medium justify-between border-b-2 border-gray-200">
      <div class="px-4 py-4 ">Add Task</div>
      <div class="flex">
        <i class="py-4 far fa-clock  mr-5 text-xl text-pink-600"></i>
        <!--  <div class="py-4 p-4 mr-6 font-thin cursor-pointer border-b-2 border-purple-500"></div>  -->
        <div class="py-4 pr-4 font-thin cursor-pointer"><i class="fas fa-times right pointer mt-1 mr-1 font-24" onclick={closeEditor}></i></div>
      </div>
    </div>
    <div class="font-medium justify-between border-b-2 border-gray-200 p-4 bg-white">
      <form onsubmit={submitMe} class="form-holder ">
        <div class="flex justify-between">
          <div >
          <div>
            <div class="label">Status</div>
            <div class="button {this.event.status == ''}  {this.event.status=='done' ? 'green-btn' : ''} " onclick={ toggleDone }  >          
              <i class="fas fa-check mr-2"  if="{ eventDone(this.event)}"></i> 

                { this.event.status == 'done' ? 'Done' : 'Not Done' } 
            </div>
            <div class="mt-2 mb-2">
              <div class="label">Time Taken</div>
              <div class="button {this.event.active == true ? 'green-btn' : ''} " onclick={ toggleActive }  >          
                <i class="fas fa-check mr-2" if={this.event.active == true }></i> 
                { this.event.active == true ? 'Stop' : 'Start' } 
              </div>
            </div>  
          </div>
        </div>
          <div class="mt-2 mb-2">
            <div class="multi-select">
              <div onclick={ setTaskSize } data-size="1" class="{this.event.taskSize == 1 ? 'selected' : ''}" >Tiny</div>
              <div onclick={ setTaskSize } data-size="3" class="{this.event.taskSize == 3 ? 'selected' : ''}">Small</div>
              <div onclick={ setTaskSize } data-size="5" class="{this.event.taskSize == 5 ? 'selected' : ''}">Medium</div>
              <div onclick={ setTaskSize } data-size="7" class="{this.event.taskSize == 7 ? 'selected' : ''}">Large</div>
              <div onclick={ setTaskSize } data-size="9" class="{this.event.taskSize == 9 ? 'selected' : ''}">Huge</div>
            </div>
          </div>      
        </div>


          <div class="separator mt-3 mb-4"></div>  
          <div class="mb-2">
            <div class="label">Title</div>
            <input type="text" name="title" onblur={ doneEdit } value={event.title}  autocomplete="off" >
          </div>
          <div class="mb-2">
            <div class="label">Date Finished</div>
            <input type="text" id="datepicker" name="date_finished" onblur={ doneEdit } value={event.dateFinished}  autocomplete="off" >
          </div>
          <div class="separator mt-5 mb-5"></div>  
          <div class="mb-2 flex">
            <div class="flex">
              <div class="label pt-1">Estimate</div>
              <input type="text" placeholder="Hours" name="estimateHour" onblur={ doneEdit } value={event.estimateHour}  autocomplete="off" >
              <input class="mr-8" type="text" placeholder="Minutes" name="estimateMinute" onblur={ doneEdit } value={event.estimateMinute}  autocomplete="off" >
            </div>
            <div class="flex">
              <div class="label">Hours taken</div>
              <input type="text" name="timeTookHour" onblur={ doneEdit } value={event.timeTookHour}  autocomplete="off" >:
              <input type="text" name="timeTookMinute" onblur={ doneEdit } value={event.timeTookMinute}  autocomplete="off" >
            </div>
          </div>
         
          <div class="separator mt-5 mb-5"></div>  
          <div>
            <div class="label vertical-top" >Info</div>
            <div class="editor"></div>
          </div>
          <div class='submit-holder'>
            <button class="button" type="submit">
              { event._id ? 'Save' : 'Create' } 
            </button>
            <div class="button" type="submit" onclick={deleteTask}>
              Delete Task
            </div>
          </div>
      </form>
    </div>    
  </div> 


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
    xObserve.listen('editSelected', 'event-form', function(event) { 
      self.dirty = false;
      self.event = event;

 
      // Set picker date time if it exists already
      if(self.event.dateFinished) {
        window.picker = self.picker

        // This timeout below MUST occur AFTER the update() timeout listed below. Otherwise the update
        // occurs and the timer can't set the object. It's strange, idk why, but it's important. 
        setTimeout(function() { 
          self.picker.setDate(self.event.dateFinished)
        }, 20)

      }

      // Set quill contents
      setTimeout(function() { 
        console.log("JSON description", self.event.jsonDescription)
          self.quill.setContents(JSON.parse(self.event.jsonDescription))

      }, 10)
      setTimeout(function() { 
        self.update()
      }, 10)
    })

    xObserve.listen('createNewEvent', 'event-form', function(event) { 
      self.event = {};
      self.update()
    })

    setTaskSize(event) { 
      size = event.target.getAttribute('data-size')
      this.event.taskSize = size
      self.update()
    }

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
      this.event.date_finished = self.picker.toString('YYYY-MM-DD')
    }

    setDirty() { 
      this.dirty = true
    }

    doneEdit(e) {
      if(this.hasActuallyChanged(this.event[e.target.name], e.target.value))  {
        this.event[e.target.name] = e.target.value;
        this.setDirty()
      }

      // 2 & 237
      let value =  parseInt(e.target.value)
      if(e.target.name == 'timeTookMinute' && value > 60) {
        self.event.timeTookHour = parseInt((parseInt(value) / 60) + self.event.timeTookHour )
        self.event.timeTookHinute = parseInt(value % 60)
        self.update()
        this.setDirty()
      }
    }

    //Turns a task on or off, meaning you are currently working on it or not.
    toggleActive()  {
      this.event.active = !this.event.active;
      if(this.event.active) {
        this.event.clockStart = Date.now()
      } else {
        let milli = Date.now() - this.event.clockStart
        let mins = parseInt(milli / 60000) || 1
        this.event.timeTookMinute = parseInt(this.event.timeTookMinute || '0') + mins 
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
        fetch('/events/' + self.event.id, {
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
        self.event.jsonDescription = self.quill.getContents();
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