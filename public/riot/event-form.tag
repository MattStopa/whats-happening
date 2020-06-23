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
            <i class="fas fa-check" if={this.event.status == 'done' } style='margin-right: 10px'></i> 

            { this.event.status == 'done' ? 'Done' : 'Not Done' } 
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
          <div class="label">Date / Time</div>
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
        <button class="button" type="submit">
          { event._id ? 'Save' : 'Create' } 
        </button>
    </form>
  </div>
 
  <script>
    this.events = null;
    let self = this;

    this.event = {};
    this.picker = null
    this.quill = null;
    this.tagify = null;


    xObserve.listen('editSelected', function(event) { 
      self.event = event;
      setTimeout(function() { 
          self.quill.setContents(self.event.json_description)

      }, 10)
      self.update()
    })

    xObserve.listen('createNewEvent', function(event) { 
      self.event = {};
      self.update()
    })

    toggleDone(e) { 
      this.event.status = this.event.status == 'done' ? 'not done' : 'done'
    }

    doneEdit(e) {
      this.event[e.target.name] = e.target.value;
    }

    tagEntered(e) { 
      if(e.code == 'Enter') {
        this.event.tags = e.target.value.split(" ")
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
      e.preventDefault()

      let method = 'POST';
      let url = 'events'

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

      }).catch(function() {
          new Noty({
            timeout: 3000,
            type: 'error',
            text: 'There was an issue saving',
        }).show();
      } )
      this.closeEditor()
    }

    closeEditor() {
      this.event = {}
      xObserve.trigger('editorClosed')
    }

  </script>
</event-form>