package algos

import (
	"testing"
)

func TestIsPowerOfTwo(t *testing.T) {
	is(t, false, isPowerOfTwo(-8))
	is(t, false, isPowerOfTwo(0))
	is(t, false, isPowerOfTwo(12))
	is(t, false, isPowerOfTwo(6))
	is(t, true, isPowerOfTwo(16))
}

func TestSingleNumber(t *testing.T) {
	is(t, 1, singleNumber([]int{2,2,1}))
	is(t, 4, singleNumber([]int{4,1,2,1,2}))
	is(t, 1, singleNumber([]int{1}))
}

func TestReverseBits(t *testing.T) {
	is(t, 2818572288, reverseBits(00000000000000000000000000010101))
}
