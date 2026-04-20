package algos

import (
	"slices"
	"testing"
)

func testTree() *BinaryNode[int] {
	return &BinaryNode[int]{
		Val: 1,
		Right: &BinaryNode[int]{
			Val:   2,
			Right: &BinaryNode[int]{Val: 4},
		},
		Left: &BinaryNode[int]{
			Val:  3,
			Left: &BinaryNode[int]{Val: 5},
		},
	}
}

func isSlice[T comparable](tb testing.TB, a, b []T) {
	tb.Helper()
	if !slices.Equal(a, b) {
		tb.Fatalf("%+v and %+v are not equal\n", a, b)
	}
}

func TestPreOrderSearch(t *testing.T) {
	isSlice(t, PreOrderSearch(testTree()), []int{1, 3, 5, 2, 4})
}

func TestPostOrderSearch(t *testing.T) {
	isSlice(t, PostOrderSearch(testTree()), []int{5, 3, 4, 2, 1})
}

func TestInOrderSearch(t *testing.T) {
	isSlice(t, InOrderSearch(testTree()), []int{5, 3, 1, 2, 4})
}

func TestSearchEmptyTree(t *testing.T) {
	isSlice(t, PreOrderSearch(nil), []int{})
	isSlice(t, InOrderSearch(nil), []int{})
	isSlice(t, PostOrderSearch(nil), []int{})
}
