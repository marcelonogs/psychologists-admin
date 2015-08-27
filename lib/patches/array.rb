class Array
  def cshift(offset)
    new_array = self.dup
    offset.times { new_array << new_array.shift }
    new_array
  end
end
