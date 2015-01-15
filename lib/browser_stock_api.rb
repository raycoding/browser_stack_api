require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
module BrowserStackApi
	class BrowserStackApiError < StandardError; end
	attr_accessor :username,:access_key,:browsers
	
	def authenticate(username,access_key)
		begin
			return "UserName or Access Key cannot be blank" if username.blank? or access_key.blank?
			url = URI.parse('http://api.browserstack.com/3')
			req = Net::HTTP::Get.new(url.path)
			req.basic_auth "#{username}", "#{access_key}"
			res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
				self.username = username
				self.access_key = access_key
			  puts res.body
			else
			  res.error!
			  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
			end
			return nil
		rescue => e
			puts "#{e.to_s}"
		end
	end

	def authenticated?
		if self.username.blank? or self.access_key.blank?
			return false
		else
			return true
		end
	end

	def browsers(all=false,flat=false)
		begin
			if !authenticated?
				raise BrowserStackApiError, "You need to authenticate yourself!"
			end
			url = ""
			if all
				url = URI.parse('http://api.browserstack.com/3/browsers?all=true')
			elsif flat
				url = URI.parse('http://api.browserstack.com/3/browsers?flat=true')
			else
				url = URI.parse('http://api.browserstack.com/3/browsers')
			end
			req = Net::HTTP::Get.new(url.path)
			req.basic_auth "#{self.username}", "#{self.access_key}"
			res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
			  self.browsers=puts res.body
			else
			  res.error!
			  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
			end
		rescue e
			puts "#{e.to_s}"
		end
	end

	def screenshot(worker_id,format)
		valid_formats=["json","xml","png"]
		begin
			if !authenticated?
				raise BrowserStackApiError, "You need to authenticate yourself!"
			elsif !valid_formats.include?(format)
				raise BrowserStackApiError, "Invalid Format Requested. Valid Formats are #{valid_formats.join(',')}"
			elsif worker_id.blank?
				raise BrowserStackApiError, "Worker ID cannot be blank to get worker screenshot!"
			end
			url = URI.parse("http://api.browserstack.com/3/worker/#{worker_id}/screenshot.#{format}")
			req = Net::HTTP::Get.new(url.path)
			req.basic_auth "#{self.username}", "#{self.access_key}"
			res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
			  puts res.body
			else
			  res.error!
			  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
			end
		rescue BrowserStackApiError => e
			puts "#{e.to_s}"
		end
	end

	def new_worker params
		valid_params = ["os", "os_version","url","browser","device","browser_version","timeout","url","name","build","project"]
		begin
			if !authenticated?
				raise BrowserStackApiError, "You need to authenticate yourself!"
			elsif !(["os", "os_version","url"] - params.keys).blank?
				raise BrowserStackApiError, "A valid request must contain a os, os_version, and a url"
			elsif !(params.keys - valid_params).blank?
				raise BrowserStackApiError, "You request contains invalid parameters - Valid Parameters are #{valid_params.join(',')}"
			else
				return get_new_worker params
			end
		rescue BrowserStackApiError => e
			puts "#{e.to_s}"
		end
	end

	def get_new_worker params
		url = URI.parse('http://api.browserstack.com/3/worker')
		req = Net::HTTP::Post.new(url.path)
		req.basic_auth "#{self.username}", "#{self.access_key}"
		req.set_form_data(params, ';')
		res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
		case res
		when Net::HTTPSuccess, Net::HTTPRedirection
		  puts res.body
		else
		  res.error!
		  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
		end
	end

	def worker_status worker_id
		begin
			if !authenticated?
				raise BrowserStackApiError, "You need to authenticate yourself!"
			elsif worker_id.blank?
				raise BrowserStackApiError, "Worker ID cannot be blank to get worker status!"
			end
			url = URI.parse("http://api.browserstack.com/3/worker/#{worker_id}")
			req = Net::HTTP::Get.new(url.path)
			req.basic_auth "#{self.username}", "#{self.access_key}"
			res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
			  puts res.body
			else
			  res.error!
			  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
			end
		rescue BrowserStackApiError => e
			puts "#{e.to_s}"
		end
	end

	def workers
		begin
			if !authenticated?
				raise BrowserStackApiError, "You need to authenticate yourself!"
			end
			url = URI.parse('http://api.browserstack.com/3/workers')
			req = Net::HTTP::Get.new(url.path)
			req.basic_auth "#{self.username}", "#{self.access_key}"
			res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
			  puts res.body
			else
			  res.error!
			  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
			end
		rescue BrowserStackApiError => e
			puts "#{e.to_s}"
		end
	end

	def api_status
		begin
			if !authenticated?
				raise BrowserStackApiError, "You need to authenticate yourself!"
			end
			url = URI.parse('http://api.browserstack.com/3/status')
			req = Net::HTTP::Get.new(url.path)
			req.basic_auth "#{self.username}", "#{self.access_key}"
			res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
			case res
			when Net::HTTPSuccess, Net::HTTPRedirection
			  puts res.body
			else
			  res.error!
			  raise BrowserStackApiError, "res.errors.full_messages.join(',')"
			end
		rescue BrowserStackApiError => e
			puts "#{e.to_s}"
		end
	end
end
