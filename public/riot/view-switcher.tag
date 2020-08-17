<view-switcher>
  <div>

    <div if={opts.view == "tasks"}>
        <b>{opts.view}</b>
      <event-list bucket={opts.bucket} class="flex-1"></event-list> 
    </div>
    <div if={opts.view == "logs"}>
      <event-logs bucket={opts.bucket} class="flex-1"></event-logs>
    </div>
    <div if={opts.view == "charts"}>
      <chart-view bucket={opts.bucket} class="flex-1"></chart-view>
    </div>

    <event-form show-editor={opts.showEditor} bucket={opts.bucket} class="flex-1"><event-form> 
  <div>

</view-switcher>