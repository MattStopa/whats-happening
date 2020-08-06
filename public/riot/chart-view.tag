<chart-view>
  <style>
    .title {
      font-weight: 800;
      cursor: pointer;
      display: flex;
      justify-content: space-between;
    }

    .title.title-header {

      padding: 20px;
      border-bottom: 1px solid #eaecef;
      margin-top: 0px;
    }

    .box.done {
      border: 3px solid #3db741;
      background: #e4fbe5;
    }

    .box .box-contents {
      padding: 20px;
      margin-bottom: 20px;
      margin-bottom: 4px;
    }

    .fa-edit {
      color: #ff9922;
      cursor: pointer;
    }

    .tags { 
      margin-left: 16px;
    }

    a.tag {
      text-decoration: none;
    }
    .number {
      position: absolute;
      height: 32px;
      width: 27px;
      margin-left: -48px;
      margin-top: -9px;
      border-radius: 24px;
      background: #b73233;
      border: 1px solid #e0e0e0;
      color: #fff;
      padding-left: 13px;
      padding-top: 9px;
      padding-right: 8px;
    }

    .title { 
      margin-left: 10px;
    }

    .progress-bar { 
      height: 20px;
      width: 95%;
      background: #fff;
      margin-left: 19px;
      margin-bottom: 16px;
      padding: 4px 5px;
      border: 2px solid #eaeaea;
      border-radius: 5px;
      text-align: center;
    }

    .progress-display {
      background: #9ebda0;
      width: 50%;
      height: 20px;
    }

    .active {
      background: #ece2cb;
      border: 2px solid #ffb200;
    }

    .time-counter {
      margin-right: 10px;
      background: #b37e00;
      color: #fff;
      padding: 5px;
      border-radius: 6px;
    }

    .time-taken {
      margin-left: 20px;
      border: 2px solid #fbfbff;
      border-radius: 7px;
      padding: 5px 12px;
      font-size: 17px;
      background: #b591dd;
      color: #fff;
      height: fit-content;
      margin-top: 19px;
    }

    .time-taken-mini {
      border: 2px solid #fbfbff;
      border-radius: 7px;
      padding: 5px 12px;
      font-size: 14px;
      background: #7b7a7a;
      color: #fff;
      height: fit-content;
    }

    .box { padding-bottom: 22px; }

  </style>

  <div>
    <h2>Charts</h2>
  </div>

  <script>
    new EventService().forChart(self.bucket._id.$oid, function(json) { 
      xObserve.trigger('bucketResults', json)
      self.events = json
      self.rerender()
    })

  </script>
</chart-view>