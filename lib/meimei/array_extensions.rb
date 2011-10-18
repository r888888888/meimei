module ArrayExtensions
  def pick_random
    return self[rand(size)]
  end
end

Array.__send__(:include, ArrayExtensions)
