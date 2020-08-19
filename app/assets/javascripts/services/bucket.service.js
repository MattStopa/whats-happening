function BucketService() { 
  this.index = function(cb) { 
      fetch('/buckets.json')
          .then(function(response) {
              return response.json()
          }).then(function(json) {
              cb(json)
          }).catch(function(ex) {
              console.log('parsing failed', ex)
          })
  }

  this.create = function(data, cb) { 
    fetch('/buckets.json')
    .then(function(response) {
        return response.json()
    }).then(function(json) {
        cb(json)
    }).catch(function(ex) {
        console.log('parsing failed', ex)
    })
  }

}