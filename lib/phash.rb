module Phash
  def self.distance(a,b)
    (a.to_i(16) ^ b.to_i(16)).to_s(2).count("1")
  end
end
