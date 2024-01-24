package internal

import "strings"

func BeginsWith(s string, substr string) bool {
	return strings.Index(s, substr) == 0
}
