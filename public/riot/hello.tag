<hello>
  <style>
    .title {
        font-weight: 800;
    }
  </style>

  <p>Hello { name }!</p>

  
  <div each="{event in events}">
    <div class='title'>{event.title}</div>
    <div>{event.description}</div>
  </div>

    <div>

    </div>

  <script>
    this.name = "Jon"; 
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
</hello>