<bucket-selector>
  <div class="bucket-panel">
    <div class="rounded p-2 bg-green-500 cursor-pointer m-2 mt-1 text-center font-bold" onclick="addBucket()">Create Bucket</div>
    <input onkeyup={keyUp} class="shadow appearance-none border border-gray-400 rounded py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline mx-2 ">

    <ul>
      <li each="{bucket in opts.buckets}" onclick="{setBucket}" class="mx-2">
        <div class="flex justify-between">
          <div>
            <i class="fas fa-fill" aria-hidden="true"></i>{bucket.name}
          </div>
          <div>
            <div class="p-2 py-1 cursor-pointer text-black bg-gray-300 inline-block rounded">
              <i class="fas fa-plus" aria-hidden="true"></i>
            </div>
          </div>
        </div>
      </li>
  </div>

  <script>
    let self = this
    let showBucket = false;
    setBucket = function(e) {
      self.opts.onselected(e)
    }

    addBucket = function() { 
      self.showBucket = true
    }

    keyUp = function(e) { 
      if(e.key == "Enter"){ 
        new BucketService().create({ name: bucket }, function() {
          console.log("results")
        })
      }
    }
  </script>
</bucket-selector>  