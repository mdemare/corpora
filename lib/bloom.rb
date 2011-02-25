require 'digest/sha1'

class Bloom
  attr_reader :bitfield,:size  
  
  DIGEST = Digest::SHA2.new(256)
  
  def Bloom.from_s(s)
    b=Bloom.new(8*s.size)
    b.instance_eval {@data = s}
    b
  end
  
  def Bloom.offsets(item, size)
    DIGEST.digest(item).unpack("vvvvvvvvvv").map {|x| x % size }
  end
  
  def initialize(bitsize)
    @size = bitsize
    @data = "\x00" * (@size/8)
  end
  
  BITCOUNT = (0..255).map {|x| x.to_s(2).count("1") }
  def cardinality
    @data.each_byte.inject(0){|sum,x| sum+BITCOUNT[x]}
  end
  
  def offsets(item)
    Bloom.offsets(item, @size)
  end
  
  def set_bit(i)
    x = @data.getbyte(i/8)
    @data.setbyte(i/8, x | (1 << (i % 8)))
  end
  
  def get_bit(i)
    (@data.getbyte(i/8) | (1 << (i % 8))) != 0
  end
  
  def add(item)
    offsets(item).each { |i| set_bit(i) }
  end
  
  def includes?(item)
    offsets(item).all? { |i| get_bit(i) }
  end
  
  def to_s
    @data
  end
  
  def inspect
    "Bloom filter of size #{@size} and cardinality #{cardinality}"
  end
end
