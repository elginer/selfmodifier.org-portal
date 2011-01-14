require "active_record"

require "openssl"

require "selfmodifier/lib/log"

module SelfModifier

	# Moderators
	class Moderator < ActiveRecord::Base
		validates_uniqueness_of "username"

		def Moderator.register username, password
			log "Registering mod: #{username}"
			user = Moderator.new :username => username, :password => md5(password)
			user.save
		end

		def Moderator.authenticate username, password
			log "Login attempt for: #{username}"
			mod = Moderator.find_by_username_and_password(username, md5(password))
			if mod
				log "Login success for: #{username}"
			else
				log "Login failure for: #{username}"
			end
			mod
		end

		# Return an md5 hash of a string
		def Moderator.md5 pass
			OpenSSL::Digest::MD5.new(pass).to_s
		end
	end

end
