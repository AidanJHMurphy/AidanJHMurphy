go test ./... -coverprofile=c.out | grep "FAIL" ; go tool cover -html=c.out && rm c.out
