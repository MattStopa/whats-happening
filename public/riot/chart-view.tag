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

    <h6>Spike</h6>
    <canvas id="barChart" width="400" height="100"></canvas>
    <h6>Burn Down</h6>
    <canvas id="burnDown" width="400" height="100"></canvas>
    <h6>Build Up</h6>
    <canvas id="buildUp" width="400" height="100"></canvas>    
  </div>

  <script>

    this.bucket = this.opts.bucket
    let self = this;

    drawChart(data, type, name) {
      var ctx = document.getElementById(name);

      var myChart = new Chart(ctx, {
          type: type,
          data: {
              labels: data.labels,
              datasets: [{
                  label: '# of tasks',
                  data: data.data,
                  backgroundColor: [
                      'rgba(255, 99, 132, 0.2)',
                      'rgba(54, 162, 235, 0.2)',
                      'rgba(255, 206, 86, 0.2)',
                      'rgba(75, 192, 192, 0.2)',
                      'rgba(153, 102, 255, 0.2)',
                      'rgba(255, 159, 64, 0.2)'
                  ],
                  borderColor: [
                      'rgba(255, 99, 132, 1)',
                      'rgba(54, 162, 235, 1)',
                      'rgba(255, 206, 86, 1)',
                      'rgba(75, 192, 192, 1)',
                      'rgba(153, 102, 255, 1)',
                      'rgba(255, 159, 64, 1)'
                  ],
                  borderWidth: 1
              }]
          },
          options: {
              scales: {
                  yAxes: [{
                      ticks: {
                          beginAtZero: true
                      }
                  }]
              }
          }
      });
    }

    this.on('update', function() {
      if(!this.bucket || (this.opts.bucket && this.bucket.name != this.opts.bucket.name)) {
        this.bucket = this.opts.bucket
      }
      this.redrawCharts()
    })

    redrawCharts() { 
      new EventService().generateChart(this.bucket._id.$oid, 30, 'bar', function(json) {
        self.drawChart(json, 'bar', 'barChart')
      })

      new EventService().generateChart(this.bucket._id.$oid, 30, 'burn', function(json) {
        self.drawChart(json, 'line', 'burnDown')
      })

      new EventService().generateChart(this.bucket._id.$oid, 30, 'build', function(json) {
        self.drawChart(json, 'line', 'buildUp')
      })
    }
    


  </script>
</chart-view>