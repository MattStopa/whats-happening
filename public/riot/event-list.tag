<event-list>
  <style>
    .title {
      font-weight: 800;
    }

    .box .box-contents {
      padding: 20px;
      margin-bottom: 20px;
    }


    .fa-edit {
      color: #ff9922;
      cursor: pointer;
    }
  </style>
  
  <div each="{event in events}" class="box shadow1">
    <div class='title header'>{event.title} <i class="far fa-edit right" onclick={edit}></i></div>
    <div class="box-contents">
      <quill-editor contents={event.json_description}></quill-editor>
    </div>
  </div>

  <script>

    this.events = null;
    let self = this;

    edit(e) {
      xObserve.trigger('editSelected', e.item.event)
    }

    new EventService().index(function(json) { 
      self.events = json
      self.update()
    }) 
    
  </script>
</event-list>