require 'bitset'
require 'digest/sha1'

class Bloom
  attr_reader :bitfield
  
  def Bloom.from_s(hex)
    (b=Bloom.new(0)).instance_eval{ @bitfield = Bitset.from_s(hex.to_i(16).to_s(2).rjust(4*hex.size,"0")) }
    c
  end
  
  def Bloom.offsets(item, size)
    Digest::SHA1.digest(item).unpack("VVVV").map {|x| x % size }
  end
  
  def initialize(bitsize)
    @bitfield = Bitset.new(bitsize)
  end
  
  def offsets(item)
    Bloom.offsets(item, @bitfield.size)
  end
  
  def add(item)
    offsets(item).each { |i| @bitfield[i] = true }
  end
  
  def includes?(item)
    offsets(item).all? { |i| @bitfield[i] }
  end
  
  def to_s
    bfs = @bitfield.to_s
    bfs.to_i(2).to_s(16).rjust(bfs.size / 4, '0')
  end
end
