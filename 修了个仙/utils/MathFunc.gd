extends Node



#L：决定了函数的上限值，也就是随着x增大，函数值无限接近但永远不会超过的值。
#k：控制了曲线的陡峭程度。较大的k值会使曲线更陡，而较小的k值会使曲线更加平缓。
#x0：S型曲线的中点位置。通过调整x0，可以左右移动整个曲线。
func sigmoid_growth(x: float, L: float = 100.0, k: float = 0.03, x0: float = 100.0) -> float:
	# L 是曲线的最大值（即无限接近但不会达到的值）
	# k 是陡度
	# x0 是S型曲线的中点
	return L / (1 + exp(-k * (x - x0)))
