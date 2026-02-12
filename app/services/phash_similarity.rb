class PhashSimilarity
  MAX_BITS = 64.0

  class << self
    def call(hash1, hash2)
      return 0.0 if hash1.blank? || hash2.blank?

      x = hash1.to_i(16)
      y = hash2.to_i(16)

      distance = hamming_distance(x ^ y)
      ((MAX_BITS - distance) * 100.0) / MAX_BITS
    end

    private

    # Brian Kernighan’s algorithm
    def hamming_distance(v)
      count = 0
      while v != 0
        v &= v - 1
        count += 1
      end
      count
    end
  end
end
