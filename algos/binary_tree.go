package algos

type BinaryNode[T any] struct {
	Val   T
	Right *BinaryNode[T]
	Left  *BinaryNode[T]
}

func InOrderSearch(head *BinaryNode[int]) []int { return inOrderSearchLoop(head, []int{}) }
func inOrderSearchLoop(node *BinaryNode[int], path []int) []int {
	if node == nil {
		return path
	}
	path = inOrderSearchLoop(node.Left, path)
	path = append(path, node.Val)
	return inOrderSearchLoop(node.Right, path)
}

func PreOrderSearch(head *BinaryNode[int]) []int { return preOrderSearchLoop(head, []int{}) }
func preOrderSearchLoop(node *BinaryNode[int], path []int) []int {
	if node == nil {
		return path
	}
	path = append(path, node.Val)
	path = preOrderSearchLoop(node.Left, path)
	return preOrderSearchLoop(node.Right, path)
}

func PostOrderSearch(head *BinaryNode[int]) []int { return postOrderSearchLoop(head, []int{}) }
func postOrderSearchLoop(node *BinaryNode[int], path []int) []int {
	if node == nil {
		return path
	}
	path = postOrderSearchLoop(node.Left, path)
	path = postOrderSearchLoop(node.Right, path)
	return append(path, node.Val)
}
