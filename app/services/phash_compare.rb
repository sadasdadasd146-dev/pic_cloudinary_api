class PhashCompare
  def self.similarity(hash1, hash2)
    return 0 if hash1.nil? || hash2.nil?

    b1 = hash1.to_i(16)
    b2 = hash2.to_i(16)

    distance = (b1 ^ b2).to_s(2).count("1")
    similarity = (64 - distance) / 64.0 * 100

    similarity
  end
end
