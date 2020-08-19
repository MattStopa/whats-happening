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
	
  this.allBuckets = function(cb) { 
    let query = ` 
	    query {
        bucket {
            id
            name
				}
			}
		`
		graphQl(query, cb)
  }

  this.create = function(data, cb) { 
    let method = 'POST';
    let url = 'events'

    self.event.bucket = self.opts.bucket

    if(self.event._id) {
      url = '/events/' + self.event._id['$oid']
      method = 'PUT'
    }

    fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ event: self.event })
    }).then(function() { 
      new Noty({
          timeout: 3000,
          type: 'success',
          text: 'Successfully Saved',
      }).show();
      
      self.dirty = false;  
      if(e) {
        self.closeEditor()
      }


    }).catch(function() {
        new Noty({
          timeout: 3000,
          type: 'error',
          text: 'There was an issue saving',
      }).show();
    } )


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