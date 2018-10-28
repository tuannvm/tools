package check

import "testing"

func TestIsValidBracket(t *testing.T) {
	testCases := []struct {
		str  string
		want bool
	}{
		{
			"(123",
			false,
		},
		{
			"(123)",
			true,
		},
	}

	for _, testCase := range testCases {
		got := IsValidBracket(testCase.str)

		if got != testCase.want {
			t.Errorf("check %v is valid, got %v want %v", testCase.str, got, testCase.want)
		}
	}
}
