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
  </style>
  
  <div class="box shadow1">
    <h2 class="header">Event Details <i class="fas fa-times right pointer"></i></h2>
    <form onsubmit={submitMe} class="form-holder ">
        <div>
          <div class="label">Title</div>
          <input type="text" name="title" onblur={ doneEdit } value={event.title}  autocomplete="off" >
        </div>
        <div>
          <div class="label" style='vertical-align: top'>Description</div>
          <div class="editor"></div>
        </div>
        <div>
          <div>
            <div class="label">Address</div>
            <input id="autocomplete" type="text" name="address" value={event.address} onblur={ doneEdit } autocomplete="off" >
          </div>
          <div style="font-size: 10px; margin-left: 104px;">Lat {event.lat} / Long {event.lng}</div>
        </div>
        <div>
          <div class="label">Date / Time</div>
          <input type="text" id="datepicker" name="event_occured" onblur={ doneEdit } value={event.event_occured}  autocomplete="off" >
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

    doneEdit(e) {
      this.event[e.target.name] = e.target.value;
    };

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

      var options = {
        modules: {
          toolbar: [
            ['bold', 'italic', 'underline', 'strike'], 
            ['blockquote', 'code-block'], 
            [{ 'header': 1 }, { 'header': 2 }], 
            [{ 'script': 'sub'}, { 'script': 'super' }],
            [{ 'indent': '-1'}, { 'indent': '+1' }], 
            [{ 'size': ['small', false, 'large', 'huge'] }], 
            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
            [{ 'color': [] }, { 'background': [] }], 
            [{ 'font': [] }], 
            [{ 'align': [] }],
            [ 'clean' ] 
          ]
        },
        placeholder: 'Compose an epic...',
        theme: 'snow'
      };

      this.quill = new Quill('.editor', options); 

      this.quill.on('text-change', function(delta, oldDelta, source) {
        self.event.json_description = self.quill.getContents();
      });

      setTimeout(function(){

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
      }, 1000)

    })

    
    submitMe(e) {
      e.preventDefault()

      fetch('/events/' + self.event.id, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ event: self.event })
      })
    }

  </script>
</event-form>