<event-list>
  <style>
    .title {
      font-weight: 800;
      cursor: pointer;
      display: flex;
      justify-content: space-between;
    }

    .box .box-contents {
      padding: 20px;
      margin-bottom: 20px;
    }


    .fa-edit {
      color: #ff9922;
      cursor: pointer;
    }

    .tags { 
      margin-left: 16px;
    }
  </style>

  <div style="height: 50.25rem; overflow-x: scroll">
    <div each="{event in events}" class="box shadow1">
      <div class='title header' onclick={navToEvent}>
        <span>{event.title}</span>
        <span>{event.event_date_display}</span>
        
      </div>
      <div class="box-contents">
        <div class="tags">
          <div class="tag pointer" each={tag in event.tags}>{tag.value}</div>
          <i class="far fa-edit right" onclick={edit}></i>
        </div>
        <quill-editor contents={event.json_description}></quill-editor>
      </div>
    </div>
  </div>

  <script>

    this.events = null;
    let self = this;

    navToEvent(e) { 
      e.item.event['displayIndex'] = this.events.indexOf(e.item.event)
      xObserve.trigger('changeMapLocation', e.item.event)
    }

    edit(e) {
      xObserve.trigger('editSelected', e.item.event)
    }

    new EventService().index(function(json) { 
      self.events = json
      self.update()
    }) 
    
  </script>
</event-list>