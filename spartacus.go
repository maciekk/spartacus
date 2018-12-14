package main

import (
  "fmt"	
  "net/http"
  "os"
  "sort"
  "strings"
)

func getEnvironMap() ([]string, map[string]string) {
  d := make(map[string]string)
  keys := make([]string, 0)
  for _, e := range(os.Environ()) {
    pair := strings.Split(e, "=")
    k := pair[0]
    v := pair[1]
    d[k] = v
    keys = append(keys, k)
  }
  return keys, d
}

func sayHello(w http.ResponseWriter, r *http.Request) {
  message := "<h1>*I* am Spartacus!</h1>\n"
  message += "Here are my environment variables:<p>"

  keys, d := getEnvironMap()
  sort.Strings(keys)
  for _, k := range(keys) {
    message += fmt.Sprintf("%s=%s<br>\n", k, d[k])
  }
  w.Write([]byte(message))
}

func main() {
  http.HandleFunc("/", sayHello)
  if err := http.ListenAndServe(":8080", nil); err != nil {
    panic(err)
  }
}
