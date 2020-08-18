<chart-view>

  <div class="chart-view">
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