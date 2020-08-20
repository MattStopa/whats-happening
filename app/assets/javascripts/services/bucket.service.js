function BucketService() { 
  this.index = function(cb) { 
    let query = `
      query {
        bucket {
          id
          name
        }
      }
    `
    graphQl(query, function(data) { 
      cb(data.data.bucket)
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
    let idQuery = data.id ? `,id:"${data.id}"`: ''
    let query = `
      mutation {
        createBucket(
          input:{
            userID:"${me.id}",
            name:"${data.name}",
            ${idQuery}
          }   
        ) {
          name
          id
        }
      }
    `
    graphQl(query, cb)
  }

  this.delete = function(data, cb) { 
    let query = `
      mutation {
        deleteBucket(
          input:{
            userID:"${me.id}",
            id:"${data.id}"
          }   
        ) {
          name
          id
        }
      }
    `
    graphQl(query, cb)
  }

}