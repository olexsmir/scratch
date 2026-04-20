package algos

// leetcode: 231
func isPowerOfTwo(n int) bool {
	// O(log n)
	// if n <= 0 { return false }
	// for n%2 == 0 { n /= 2 }
	// return n == 1

	// O(1)
	return n > 0 && n&(n-1) == 0
}

// lettcode: 136
func singleNumber(nums []int) int {
	// O(2n)
	// cache := make(map[int]struct{})
	// for _, num := range nums {
	// 	_, exists := cache[num]
	// 	if exists { delete(cache, num); continue }
	// 	cache[num] = struct{}{}
	// }
	// for k := range cache { return k }
	// return 0

	// O(1)
	// a XOR a == 0
	// a XOR 0 == a
	missedNumber := 0
	for _, num := range nums {
		missedNumber ^= num
	}
	return missedNumber
}

// leetcode: 190
func reverseBits(number int) int {
	var result int
	for range 32 {
		result = (result << 1) | (number & 1)
		number >>= 1
	}
	return result
}
