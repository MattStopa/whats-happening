<timer>

  <p>Seconds Elapsed: { time }</p>

  this.time = opts.start || 0

  this.tick = function() {
    this.update({ time: ++this.time })
  }

  var timer = setInterval(this.tick.bind(this), 1000)

  alert("GOT HER")

  this.on("unmount", function() {
    clearInterval(timer)
  })

</timer>