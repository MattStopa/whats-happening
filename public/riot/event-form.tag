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
  </style>
  
  <div class="box shadow1">
    <h2 class="header">Event Details <i class="fas fa-times right pointer" onclick={closeEditor}></i></h2>
    <form onsubmit={submitMe} class="form-holder ">
        <div>
          <div class="label">Title</div>
          <input type="text" name="title" onblur={ doneEdit } value={event.title}  autocomplete="off" >
        </div>
        <div>
          <div>
            <div class="label">Address</div>
            <input id="autocomplete" type="text" name="address" value={event.address} onblur={ doneEdit } autocomplete="off" >
          </div>
          <div style="font-size: 10px; margin-left: 104px;">Lat {event.lat} / Long {event.lng}</div>
        </div>
        <div>
          <div class="label">Tags</div>
          <div class="tag-holder tag-input"></div>
        </div>
        <div>
          <div class="label">Date / Time</div>
          <input type="text" id="datepicker" name="event_occured" onblur={ doneEdit } value={event.event_occured}  autocomplete="off" >
        </div>
        <div>
          <div class="label" style='vertical-align: top'>Description</div>
          <div class="editor"></div>
        </div>
        <button class="button" type="submit">{ event.id ? 'Save' : 'Create' } </button>
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
        if(self.event.event_occured) {
          self.picker.setDate(new Date(self.event.event_occured))
          self.quill.setContents(self.event.json_description)
          self.quill.setContents(quill)
        }
      }, 10)
      self.update()
    })

    xObserve.listen('createNewEvent', function(event) { 
      self.event = {};
      self.update()
    })


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

      setTimeout(function(){

        self.tagify.addTags(self.event.tags)

        var input = document.getElementById('autocomplete');
        var autocomplete = new google.maps.places.Autocomplete(input);

        autocomplete.bindTo('bounds', window.map)

        autocomplete.addListener('place_changed', function(event) {
          var place = autocomplete.getPlace();
          if (!place.geometry) {
            // User entered the name of a Place that was not suggested and
            // pressed the Enter key, or the Place Details request failed.
            window.alert("No details available for input: '" + place.name + "'");
            return;
          }

          self.event.lat = place.geometry.location.lat()
          self.event.lng = place.geometry.location.lng()
          self.event.address = place.formatted_address
          self.update()

          addMarker(place.geometry.location, 'Click Generated Marker', window.map)

          // If the place has a geometry, then present it on a map.
          if (place.geometry.viewport) {
            map.fitBounds(place.geometry.viewport);
          } else {
            map.setCenter(place.geometry.location);
            map.setZoom(17);  // Why 17? Because it looks good.
          }

        });
      }, 50)

    })

    
    submitMe(e) {
      e.preventDefault()

      self.event.tags = self.tagify.value

      let method = 'POST';
      let url = 'events'

      if(self.event.id) {
        url = '/events/' + self.event.id
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
    }

    closeEditor() {
      this.event = {}
      xObserve.trigger('editorClosed')
    }

  </script>
</event-form>