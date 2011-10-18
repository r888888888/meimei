class PersistentHash
	def initialize(file_path, commit_interval = 1)
		@commit_interval = commit_interval
		@commit_count = 0
		@file_path = file_path
		restore!
		unless @hash.is_a?(Hash)
			@hash = {}
			commit!
		end
	end

	def restore!
		if File.exist?(@file_path)
			mode = File::RDONLY
		else
			return
		end

		File.open(@file_path, mode) do |f|
			@hash = Marshal.restore(f)
		end
	end

	def commit!
		File.open(@file_path, File::WRONLY | File::CREAT) do |f|
			Marshal.dump(@hash, f)
		end
	end

	def []=(key, value)
		@hash[key] = value
		@commit_count += 1
		if @commit_count >= @commit_interval
			@commit_count = 0
			commit!
		end
	end

	def method_missing(name, *params, &block)
		@hash.send(name, *params, &block)
	end
end
