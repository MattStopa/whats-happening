<main-view>
  <style>
    .page-header {
      height: 48px;
      width: 100%;
      background-color: #145f9c;
      margin-bottom: 10px;
      padding-top: 20px;
      border-bottom: 5px solid #adddff;
    }

    .logo {
      color: #fff;
      margin-top: -24px;
      margin-left: 400px;
      font-size: 39px;
      font-family: 'Coiny', cursive;
    }

    .search-box {
      margin-top: -13px;
      display: inline-block;
      vertical-align: center;
      width: 800px;
      font-size: 27px;
      margin-left: 39px;
      border-radius: 5px;
      background: #ffffff;
      padding: 3px;
      padding-left: 21px;
      margin-bottom: 9px;
      color: #72bcea;
    }

  </style>

    <div class="page-header">
      <div class='logo'>
        <span style="color:#c0d1ff; font-size: 50px">W</span>haazup       
        <input type="text" class="search-box" placeholder="Type a term in here">
      </div>

    </div>
    <div class="flex">
        <div id="map" class="flex-1"></div>
        <event-list class="flex-1"></event-list> 
        <div if={showEditor}> 
            <event-form class="flex-1"><event-form> 
        </div>
    <div>

  <script>
    this.showEditor = false
    self = this
    xObserve.listen('editorClosed', function(event) { 
      self.showEditor = false
      self.update()
    })

    xObserve.listen('editSelected', function(event) { 
      self.showEditor = true
      self.update()
    })
  </script>
</main-view>