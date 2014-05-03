Ruby Gem integrating RESTFUL API for BrowserStack

Usage

gem install 'browser_stack_api'

include BrowserStackApi in any Ruby class

e.g 

class A
include BrowserStackApi
end

# Available Methods

a = A.new
a.authenticate(username,access_key)

a.new_worker({"os"=>"Windows","os_version"=>"7","url"=>"https://github.com/404","browser"=>"firefox","browser_version"=>"27.0"})
Response is {"url":"https://github.com/404","id":10732150}

a.screenshot(10732150,"json")
{"url":"https://s3.amazonaws.com/testautomation/4fe2c5117cbb4f24d7fd53c44cb5c9d83edcb125/js-screenshot-1399124070.png"}

Or you can also try a.screenshot(worker_id,"xml") or a.screenshot(worker_id,"xml")

a.workers
[{"browser_version":"27.0","browser_url":"http://www.browserstack.com/automate/builds/09ac63e672c57f52273e7c0f7e4486bb1d2da4aa/sessions/4fe2c5117cbb4f24d7fd53c44cb5c9d83edcb125","os_version":"7","status":"running","browser":"firefox","os":"Windows","id":10732150}]


a.api_status

