
<event-form>
  <style>
    .title {
        font-weight: 800;
    }
  </style>
  
  <div>

    <form onsubmit={submitMe}>
        Title
        <input type="text" name="title" onblur={ doneEdit } >
        Description
        <input type="text" name="description" onblur={ doneEdit }  >

        Coord X
        <input type="text" name="coord_x" onblur={ doneEdit }  >

        Coord Y
        <input type="text" name="coord_y" onblur={ doneEdit }  >

        <button type="submit">Create</button>

    </form>

  
  </div>
 
  <script>
    this.events = null;
    var self = this;


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