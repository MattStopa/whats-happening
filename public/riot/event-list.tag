<event-list>
  <style>
    .title {
      font-weight: 800;
    }

    .box .box-contents {
      padding: 20px;
      margin-bottom: 20px;
    }
  </style>
  
  <div each="{event in events}" class="box shadow1">
    <div class='title header'>{event.title}</div>
    <div class="box-contents">
      <div>{event.description}</div>
    </div>
  </div>

  <script>
    this.events = null;

    function getData(self) { 
        fetch('/events.json')
            .then(function(response) {
                return response.json()
            }).then(function(json) {
                self.events = json
                self.update()

            }).catch(function(ex) {
                console.log('parsing failed', ex)
            })
    }

    getData(this)
    
  </script>
</event-list>