class Bloom
  attr_reader :bitfield
  
  def initialize(bitsize)
    @bitfield = Bitset.new(bitsize)
  end
  
  def add(item)
    Digest::SHA1.digest(item).unpack("VVVV").each { |hi| @bitfield[hi % @bitfield.size] = true }
  end
  
  def includes?(item)
    Digest::SHA1.digest(item).unpack("VVVV").all? { |hi| @bitfield[hi % @bitfield.size] }
  end
end
