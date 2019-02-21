<event-list>
  <style>
    .title {
        font-weight: 800;
    }
  </style>
  
  <div each="{event in events}">
    <div class='title'>{event.title}</div>
    <div>{event.description}</div>
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