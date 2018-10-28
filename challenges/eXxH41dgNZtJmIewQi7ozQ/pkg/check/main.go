package check

// IsValidBracket check for valid bracket
func IsValidBracket(str string) bool {
	var pre, suf int

	for _, char := range str {
		switch string(char) {
		case "(":
			pre++
			suf++
		case ")":
			pre--
			suf--
		}
		if pre < 0 {
			pre = 0
		}

		if suf < 0 {
			return false
		}
	}
	return pre == 0
}
